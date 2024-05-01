import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomEditFormField extends StatelessWidget {
  final String labelText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool readOnly;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final String initialValue;
  final Widget? prefixIcon;

  const CustomEditFormField({
    super.key,
    required this.labelText,
    this.onSaved,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.maxLines = 1,
    this.onTap,
    this.inputFormatters,
    this.initialValue = '',
    this.prefixIcon
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
        onSaved: onSaved,
        validator: validator,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        initialValue: initialValue,
      ),
    );
  }
}
