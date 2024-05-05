import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/widgets/garages/garage_detail_panel.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool showInstructionSheet = true;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    fetchGarages();
    loadMapStyle();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      determinePosition();
    } else {
      setState(() {
        initialPosition = const LatLng(-17.7833, -63.1821);
      });
    }
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
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void loadMapStyle() async {
    _mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
  }

  void fetchGarages() {
    GarageService().garagesStream().listen((List<Garage> garages) {
      setState(() {
        markers = garages.map((garage) {
          bool isOpen = checkIfOpen(garage);
          List<String> parts = garage.location.coordinates.split(',');
          double latitude = double.parse(parts[0].trim());
          double longitude = double.parse(parts[1].trim());
          return Marker(
            markerId: MarkerId(garage.id),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: garage.name,
              snippet: isOpen ? 'ABIERTO' : 'CERRADO',
            ),
            onTap: () => _onMarkerTapped(garage),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                isOpen ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueRed),
          );
        }).toSet();
      });
    });
  }

  bool checkIfOpen(Garage garage) {
    DateTime now = DateTime.now();
    String currentDay = DateFormat('EEEE').format(now).toLowerCase();
    int currentTime = now.hour * 100 + now.minute;

    return garage.availableTime.any((day) {
      if (day.day.toLowerCase() == currentDay) {
        return day.availableTime?.any((time) {
              int startTime = _getTimeAsInt(time.startTime);
              int endTime = _getTimeAsInt(time.endTime);
              return currentTime >= startTime && currentTime <= endTime;
            }) ??
            false;
      }
      return false;
    });
  }

  int _getTimeAsInt(String timeStr) {
    List<String> parts = timeStr.split(':');
    return int.parse(parts[0]) * 100 + int.parse(parts[1]);
  }

  void _onMarkerTapped(Garage garage) {
    setState(() {
      selectedGarage = garage;
      showInstructionSheet = false;
      draggableController.animateTo(
        0.5,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          initialPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: initialPosition ??
                        LatLng(-17.7833,
                            -63.1821), // Default location if GPS not enabled
                    zoom: 18,
                  ),
                  style: _mapStyle,
                  markers: markers,
                  onTap: (_) {
                    setState(() {
                      draggableController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                      showInstructionSheet = true;
                    });
                  },
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                ),
          if (showInstructionSheet)
            Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "PRESIONA EN UN",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.pin_drop_rounded,
                              color: Colors.orange,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ))),
          if (selectedGarage != null)
            GarageDetailPanel(
              garage: selectedGarage!,
              controller: draggableController,
              onPanelClosed: () => setState(() => showInstructionSheet = true),
            ),
        ],
      ),
    );
  }
}
