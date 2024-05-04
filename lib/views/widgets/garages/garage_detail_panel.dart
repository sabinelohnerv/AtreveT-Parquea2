import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';

class GarageDetailPanel extends StatelessWidget {
  final Garage garage;
  final DraggableScrollableController controller;

  const GarageDetailPanel({Key? key, required this.garage, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(16),
            children: [
              Text(garage.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              if (garage.imgUrl != null && garage.imgUrl!.isNotEmpty)
                Image.network(garage.imgUrl!, height: 200, fit: BoxFit.cover),
              Divider(),
              Text('Espacios disponibles: ${garage.numberOfSpaces}', style: TextStyle(fontSize: 16)),
              Text('Calificación: ${garage.rating.toStringAsFixed(1)} / 5', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Detalles:', style: TextStyle(fontWeight: FontWeight.bold)),
              if (garage.details != null && garage.details!.isNotEmpty)
                Text(garage.details!.join(', ')),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implementar lógica para reserva o navegación
                },
                child: Text('Reservar Espacio'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Implementar lógica para obtener direcciones
                },
                child: Text('Obtener Direcciones'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
