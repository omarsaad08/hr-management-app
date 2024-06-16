import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

TextFormField customTextField(
    {required TextEditingController controller, required String label}) {
  // TextEditingController
  return TextFormField(
      controller: controller,
      cursorColor: clr(1),
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: clr(1), width: 2)),
          labelText: label,
          labelStyle: TextStyle(color: clr(1)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            gapPadding: 8,
          )));
}
