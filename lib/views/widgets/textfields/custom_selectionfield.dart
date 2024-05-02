import 'package:flutter/material.dart';

class CustomSelectionField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final VoidCallback onTap;
  final Widget? prefixIcon;

  const CustomSelectionField(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.onTap,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
            label: Text(labelText),
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            hintText: 'Toca para seleccionar',
            prefixIcon: prefixIcon),
        onTap: onTap,
        validator: (value) =>
            value!.isEmpty ? 'Este campo es obligatorio.' : null,
      ),
    );
  }
}
