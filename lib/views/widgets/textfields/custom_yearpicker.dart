import 'package:flutter/material.dart';

class YearPickerWidget extends StatefulWidget {
  final TextEditingController controller;

  const YearPickerWidget({super.key, required this.controller});

  @override
  State<YearPickerWidget> createState() => _YearPickerWidgetState();
}

class _YearPickerWidgetState extends State<YearPickerWidget> {
  void _pickYear() async {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: DateTime.now().year -
                  1900 +
                  1, // Years from 1900 to this year
              itemBuilder: (BuildContext context, int index) {
                int year = 1900 + index;
                return ListTile(
                  title: Text(year.toString()),
                  onTap: () {
                    widget.controller.text = year.toString();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        onTap: _pickYear,
        child: IgnorePointer(
          child: TextFormField(
            controller: widget.controller,
            decoration: const InputDecoration(
              labelText: 'Year',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              prefixIcon: Icon(Icons.calendar_today),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
