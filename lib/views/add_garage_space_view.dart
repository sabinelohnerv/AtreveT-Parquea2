import 'package:flutter/material.dart';

class AddGarageSpaceView extends StatefulWidget {
  const AddGarageSpaceView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddGarageSpaceViewState();
  }
}

class _AddGarageSpaceViewState extends State<AddGarageSpaceView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Agregar Espacio'),
      ),
    );
  }
}
