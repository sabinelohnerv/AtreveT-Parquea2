import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/widgets/garages/garage_detail_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Garage? selectedGarage;
  DraggableScrollableController draggableController =
      DraggableScrollableController();
  LatLng? initialPosition;
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    fetchGarages();
    determinePosition();
    loadMapStyle();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void loadMapStyle() async {
    _mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
  }

  void fetchGarages() {
    GarageService().garagesStream().listen((List<Garage> garages) {
      setState(() {
        markers = garages
            .map((garage) {
              List<String> parts = garage.location.coordinates.split(',');
              MarkerId markerId = MarkerId(garage.id);
              if (parts.length == 2) {
                double latitude = double.parse(parts[0].trim());
                double longitude = double.parse(parts[1].trim());
                return Marker(
                  markerId: markerId,
                  position: LatLng(latitude, longitude),
                  onTap: () {
                    _onMarkerTapped(garage);
                  },
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                );
              }
              return null;
            })
            .where((marker) => marker != null)
            .cast<Marker>()
            .toSet();
      });
    });
  }

  void _onMarkerTapped(Garage garage) {
    setState(() {
      selectedGarage = garage;
      draggableController.animateTo(
        0.5,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return; // Permissions are denied, next step is to inform the user.
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return; // Permissions are permanently denied, handle appropriately.
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          initialPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  style: _mapStyle,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: initialPosition!,
                    zoom: 18,
                  ),
                  markers: markers,
                  onTap: (_) {
                    setState(() {
                      draggableController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                ),
          if (selectedGarage != null)
            GarageDetailPanel(
              garage: selectedGarage!,
              controller: draggableController,
            ),
        ],
      ),
    );
  }
}
