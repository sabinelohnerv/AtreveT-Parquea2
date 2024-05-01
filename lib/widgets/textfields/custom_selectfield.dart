import 'package:flutter/material.dart';

class CustomSelectField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String labelText;
  final void Function(T?) onChanged;
  final String Function(T) itemLabelBuilder;
  final Widget? prefixIcon;

  const CustomSelectField({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.prefixIcon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: DropdownButtonFormField<T>(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon
        ),
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(itemLabelBuilder(value)),
          );
        }).toList(),
      ),
    );
  }
}
