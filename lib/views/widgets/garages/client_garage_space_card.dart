import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';

class ClientGarageSpaceCard extends StatelessWidget {
  const ClientGarageSpaceCard({
    super.key,
    required this.garageSpace,
    required this.garageNumber,
    required this.onTap,
  });

  final GarageSpace garageSpace;
  final int garageNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget determineState() {
      String stateGarage = garageSpace.state;
      Color textColor;
      String stateText;

      switch (stateGarage) {
        case 'libre':
          textColor = Colors.green;
          stateText = 'LIBRE';
          break;
        case 'reservado':
          textColor = Colors.orange;
          stateText = 'RESERVADO';
          break;
        case 'ocupado':
          textColor = Colors.blue;
          stateText = 'OCUPADO';
          break;
        case 'deshabilitado':
          textColor = Colors.red;
          stateText = 'DESHABILITADO';
          break;
        default:
          textColor = Colors.grey;
          stateText = 'DESCONOCIDO';
          break;
      }

      return Text(
        stateText,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w400),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 10, 24, 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Text(
                garageNumber.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Espacio ${garageNumber.toString()}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Alto: ${garageSpace.measurements.height}m - Ancho: ${garageSpace.measurements.width}m - Largo: ${garageSpace.measurements.length}m',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            determineState(),
          ],
        ),
      ),
    );
  }
}
