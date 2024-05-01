import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final Widget? prefixIcon;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.onSaved,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.readOnly = false,
    this.maxLines = 1,
    this.onTap,
    this.inputFormatters,
    this.prefixIcon,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.obscureText ? IconButton(
            icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
            onPressed: _togglePasswordVisibility,
          ) : null,
        ),
        onSaved: widget.onSaved,
        validator: widget.validator,
        obscureText: _isObscured,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,
        maxLines: widget.maxLines,
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }
}
