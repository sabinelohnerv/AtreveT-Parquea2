// garage_detail_widget.dart
import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';

class GarageDetailWidget extends StatelessWidget {
  final Garage garage;
  const GarageDetailWidget({Key? key, required this.garage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(garage.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Espacios disponibles: ${garage.numberOfSpaces}'),
          SizedBox(height: 10),
          Text('Calificación: ${garage.rating.toStringAsFixed(1)}'),
          // Más detalles pueden ser añadidos aquí
        ],
      ),
    );
  }
}
