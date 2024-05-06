import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumberInput extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(String)? onSaved;
  final Widget? prefixIcon;
  final int?
      decimalPlaces; // Optional, if you want to control decimal precision

  const CustomNumberInput({
    super.key,
    required this.labelText,
    required this.controller,
    this.onSaved,
    this.prefixIcon,
    this.decimalPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          prefixIcon: prefixIcon,
        ),
        controller: controller,
        onSaved: onSaved != null ? (value) => onSaved!(value!) : null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a number.';
          } else if (double.tryParse(value) == null) {
            return 'Please enter a valid number.';
          }
          return null;
        },
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          if (decimalPlaces != null)
            DecimalTextInputFormatter(decimalRange: decimalPlaces!),
        ],
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;
  static const defaultDecimalRange = 2;

  DecimalTextInputFormatter({this.decimalRange = defaultDecimalRange});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;
    if (newText.contains('.') &&
        newText.substring(newText.indexOf('.') + 1).length > decimalRange) {
      return oldValue;
    }
    return newValue;
  }
}
