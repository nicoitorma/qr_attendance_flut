import 'package:flutter/material.dart';

Duration transitionDuration = const Duration(milliseconds: 350);

InputDecoration decoration(String label) => InputDecoration(
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.red)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    labelText: label);

inputField(
      {required TextEditingController controller,
      required String label,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: decoration(label),
        onSaved: (newValue) {
          controller.text = newValue ?? '';
        },
      ),
    );
  }