import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberInput extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(String)? onSaved;
  final Widget? prefixIcon;

  const CustomNumberInput({
    super.key,
    required this.labelText,
    required this.controller,
    this.onSaved,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon
        ),
        controller: controller,
        onSaved: onSaved != null ? (value) => onSaved!(value!) : null,
        validator: (value) {
          if (value != null &&
              value.isNotEmpty &&
              int.tryParse(value) == null) {
            return 'Ingresa un número válido.';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }
}
