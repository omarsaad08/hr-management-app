import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

TextField customTextField(
    {required TextEditingController controller,
    required String label,
    bool icon = false,
    Icon? fieldIcon}) {
  // TextEditingController
  return TextField(
      controller: controller,
      cursorColor: clr(1),
      decoration: InputDecoration(
          icon: icon ? fieldIcon : null,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: clr(1), width: 2)),
          labelText: label,
          labelStyle: TextStyle(color: clr(1)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            gapPadding: 8,
          )));
}
