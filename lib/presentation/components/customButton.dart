import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

Widget customButton({
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: clr(2),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: Text(label,
          style: TextStyle(
              color: clr(0), fontSize: 22, fontWeight: FontWeight.bold)),
      onPressed: onPressed);
}
