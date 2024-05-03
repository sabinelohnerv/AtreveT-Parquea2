import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationView extends StatefulWidget {
  @override
  _SelectLocationViewState createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView> {
  LatLng? selectedLocation;
  Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    if (selectedLocation != null) {
      markers.add(
        Marker(
          markerId: MarkerId("selectedLocation"),
          position: selectedLocation!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleccionar Ubicación"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(-17.7833, -63.1821), // Centro en Santa Cruz, Bolivia
          zoom: 12,
        ),
        markers: markers,
        onTap: (position) {
          setState(() {
            selectedLocation = position;
            markers.clear();
            markers.add(Marker(
              markerId: MarkerId("selectedLocation"),
              position: position,
            ));
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedLocation != null) {
            Navigator.of(context).pop(selectedLocation);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
