import 'package:flutter/material.dart';
import 'package:parquea2/models/garage.dart';

class GarageDetailPanel extends StatefulWidget {
  final Garage garage;
  final DraggableScrollableController controller;

  const GarageDetailPanel(
      {super.key, required this.garage, required this.controller});

  @override
  _GarageDetailPanelState createState() => _GarageDetailPanelState();
}

class _GarageDetailPanelState extends State<GarageDetailPanel> {
  bool isDraggingDown = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleDrag);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleDrag);
    super.dispose();
  }

  void _handleDrag() {
    if (widget.controller.size < 0.3) {
      if (!isDraggingDown) {
        isDraggingDown = true;
        widget.controller.animateTo(
          0.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
        );
      }
    } else {
      isDraggingDown = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;

    return DraggableScrollableSheet(
      controller: widget.controller,
      initialChildSize: 0.5,
      minChildSize: 0.0,
      maxChildSize: 0.7,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: -5)
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                  child: Text(widget.garage.name,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor))),
              const SizedBox(height: 10),
              if (widget.garage.imgUrl != null &&
                  widget.garage.imgUrl!.isNotEmpty)
                Image.network(widget.garage.imgUrl!,
                    height: 200, fit: BoxFit.cover),
              const Divider(height: 20),
              ListTile(
                leading: Icon(Icons.local_parking, color: primaryColor),
                title: Text(
                    'Espacios disponibles: ${widget.garage.numberOfSpaces}'),
              ),
              ListTile(
                leading: Icon(Icons.star, color: primaryColor),
                title: Text(
                    'Calificación: ${widget.garage.rating.toStringAsFixed(1)} / 5'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('Detalles:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryColor)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.garage.details
                          ?.map((detail) => Text("• $detail",
                              style: const TextStyle(fontSize: 14)))
                          ?.toList() ??
                      [],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: ir a pantalla de reservar espacio
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Ofertar'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
