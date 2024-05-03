import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';
import 'package:parquea2/models/measurements.dart';
import 'package:parquea2/services/garage_service.dart';

class EditGarageSpaceViewModel extends ChangeNotifier {
  final GarageService _garageService;
  final String garageId;
  final GarageSpace garageSpace;

  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  List<String> selectedDetails = [];
  List<String> predefinedDetails = [
    'Estacionamiento techado',
    'Acceso sin escaleras',
    'Seguridad 24/7',
    'Cámara de vigilancia'
  ];

  bool _isUploading = false;

  EditGarageSpaceViewModel(this.garageId, this.garageSpace, this._garageService) {
    widthController.text = garageSpace.measurements.width.toString();
    heightController.text = garageSpace.measurements.height.toString();
    lengthController.text = garageSpace.measurements.length.toString();
    detailsController.text = garageSpace.details?.join(', ') ?? '';
    selectedDetails = garageSpace.details ?? [];
  }

  bool get isUploading => _isUploading;

  Future<void> updateGarageSpace() async {
  _isUploading = true;
  notifyListeners();

  Measurements updatedMeasurements = Measurements(
    width: double.parse(widthController.text),
    height: double.parse(heightController.text),
    length: double.parse(lengthController.text),
  );

  GarageSpace updatedGarageSpace = GarageSpace(
    id: garageSpace.id,
    measurements: updatedMeasurements,
    details: detailsController.text.split(', ').where((s) => s.isNotEmpty).toList(),
    state: garageSpace.state,
  );

  await _garageService.updateGarageSpace(garageId, updatedGarageSpace);

  _isUploading = false;
  notifyListeners();
}


 void showDetailsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Seleccione los detalles'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: ['Estacionamiento techado', 'Cemento'].map((detail) {
                  return CheckboxListTile(
                    title: Text(detail),
                    value: selectedDetails.contains(detail),
                    onChanged: (bool? value) {
                      if (value == true && !selectedDetails.contains(detail)) {
                        selectedDetails.add(detail);
                      } else if (value == false) {
                        selectedDetails.remove(detail);
                      }
                      setState(() {});
                      detailsController.text = selectedDetails.join(', ');
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



  @override
  void dispose() {
    widthController.dispose();
    heightController.dispose();
    lengthController.dispose();
    detailsController.dispose();
    super.dispose();
  }
}
