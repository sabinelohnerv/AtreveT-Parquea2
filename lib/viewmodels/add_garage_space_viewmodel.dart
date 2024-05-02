import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/models/measurements.dart';
import 'package:parquea2/services/garage_service.dart';

class AddGarageSpaceViewModel extends ChangeNotifier {
  final GarageService _garageService = GarageService();

  bool _isUploading = false;
  List<String>? _details;
  double width = 0;
  double height = 0;
  double length = 0;

  //Controllers

  List<String> selectedDetails = [];
  TextEditingController detailsController = TextEditingController();

  TextEditingController widthController = TextEditingController();
  TextEditingController heigthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();

  AddGarageViewModel() {
    widthController.addListener(() {
      notifyListeners();
    });
    heigthController.addListener(() {
      notifyListeners();
    });
    lengthController.addListener(() {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    widthController.dispose();
    heigthController.dispose();
    lengthController.dispose();
    super.dispose();
  }

  //Getters
  bool get isUploading => _isUploading;

  List<String>? get details => _details;

  List<String> predefinedDetails = [
    'Estacionamiento techado',
    'Cemento',
  ];

  //Setters

  set details(List<String>? value) {
    _details = value;
    notifyListeners();
  }

  //Details
  void showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Detalles del Espacio',
            style: TextStyle(fontSize: 18),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: ListBody(
                  children: predefinedDetails.map((detail) {
                    return CheckboxListTile(
                      title: Text(detail),
                      value: selectedDetails.contains(detail),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true &&
                              !selectedDetails.contains(detail)) {
                            selectedDetails.add(detail);
                          } else if (value == false) {
                            selectedDetails.remove(detail);
                          }
                        });
                        updateDetails(selectedDetails);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateDetails(List<String> newDetails) {
    selectedDetails = newDetails;
    detailsController.text = selectedDetails.join(', ');
    notifyListeners();
  }

  void updateWidth(double value) {
    width = value;
    widthController.text = value.toString();
    notifyListeners();
  }

  void updateHeight(double value) {
    height = value;
    widthController.text = value.toString();
    notifyListeners();
  }

  void updateLength(double value) {
    length = value;
    widthController.text = value.toString();
    notifyListeners();
  }

  Future<void> addGarageSpace(String garageId) async {
    _isUploading = true;
    notifyListeners();


    String garageSpaceId = "Space_${DateTime.now().millisecondsSinceEpoch}";
    Measurements measurements = Measurements(height: height, width: width, length: length);

    GarageSpace newGarage = GarageSpace(
      id: garageSpaceId,
      details: selectedDetails,
      measurements: measurements,
      state: 'libre'
    );

    await _garageService.addGarageSpaceAndUpdateSpacesCount(newGarage, garageId);
  }
}
