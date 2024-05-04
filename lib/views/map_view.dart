import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parquea2/models/garage.dart';
import 'package:parquea2/services/garage_service.dart';
import 'package:parquea2/views/widgets/garages/garage_detail_panel.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Garage? selectedGarage;
  DraggableScrollableController draggableController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    fetchGarages();
  }

  void fetchGarages() {
    GarageService().garagesStream().listen((List<Garage> garages) {
      setState(() {
        markers = garages.map((garage) {
          List<String> parts = garage.location.coordinates.split(',');
          if (parts.length == 2) {
            try {
              double latitude = double.parse(parts[0].trim());
              double longitude = double.parse(parts[1].trim());
              return Marker(
                markerId: MarkerId(garage.id),
                position: LatLng(latitude, longitude),
                onTap: () {
                  setState(() {
                    selectedGarage = garage;
                    draggableController.animateTo(0.3, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                  });
                },
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              );
            } catch (e) {
              print('Error parsing coordinates for garage ${garage.name}: ${garage.location.coordinates}');
              return null;
            }
          } else {
            print('Invalid coordinates format for garage ${garage.name}: ${garage.location.coordinates}');
            return null;
          }
        }).where((marker) => marker != null).cast<Marker>().toSet();
      });
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
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(-17.7833, -63.1821),
              zoom: 12,
            ),
            markers: markers,
            onTap: (_) {
              setState(() {
                draggableController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
              });
            },
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 40,
            left: 10,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          if (selectedGarage != null)
            GarageDetailPanel(garage: selectedGarage!, controller: draggableController)
        ],
      ),
    );
  }
}
