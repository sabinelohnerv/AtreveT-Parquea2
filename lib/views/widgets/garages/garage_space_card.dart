import 'package:flutter/material.dart';
import 'package:parquea2/models/garage_space.dart';

class GarageSpaceCard extends StatelessWidget {
  const GarageSpaceCard({
    super.key,
    required this.garageSpace,
    required this.garageNumber,
    required this.onDelete,
    required this.onEdit, required void Function() onTap, 
  });

  final GarageSpace garageSpace;
  final int garageNumber;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    Widget determineState() {
      String stateJudge = garageSpace.state;
      Color textColor;
      String stateText;

      switch (stateJudge) {
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

    return Dismissible(
      key: Key(garageSpace.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirmar eliminación"),
              content:
                  const Text("¿Estás seguro de querer eliminar este espacio de garaje?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Eliminar"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 10, 24, 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: 'Editar espacio',
            ),
          ],
        ),
      ),
    );
  }
}