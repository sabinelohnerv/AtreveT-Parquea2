import 'package:flutter/material.dart';

class CustomSelectionField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final VoidCallback onTap;
  final Widget? prefixIcon;

  const CustomSelectionField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.onTap,
    this.prefixIcon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          label: Text(labelText),
          border: const OutlineInputBorder(),
          hintText: 'Toca para seleccionar',
          prefixIcon: prefixIcon
        ),
        onTap: onTap,
        validator: (value) =>
                          value!.isEmpty ? 'Este campo es obligatorio.' : null,
      ),
    );
  }
}
