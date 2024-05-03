import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';

class ClientGarageSpaceDetails extends StatelessWidget {
  final GarageSpace garageSpace;
  final int spaceNumber;

  const ClientGarageSpaceDetails(
      {super.key, required this.garageSpace, required this.spaceNumber});

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
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.w600, fontSize: 16),
      );
    }

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Espacio $spaceNumber',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 10,
          ),
          determineState()
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'Dimensiones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              'Alto: ${garageSpace.measurements.height} m',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Text(
              'Ancho: ${garageSpace.measurements.width} m',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Text(
              'Largo: ${garageSpace.measurements.length} m',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 6),
              child: Text(
                'Detalles adicionales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
                '- ${garageSpace.details?.join("\n- ")}' ??
                    "No se proveyeron detalles para este espacio",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: FilledButton(
                child: const Text('REALIZAR OFERTA'),
                onPressed: () {
                  //TODO: Ir a pantalla de oferta
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            child: const Text(
              'Cerrar',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
