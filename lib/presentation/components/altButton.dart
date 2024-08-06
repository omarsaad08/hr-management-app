import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

Widget altButton({
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: clr(1),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: Text(label,
          style: TextStyle(
              color: clr(5), fontSize: 18, fontWeight: FontWeight.normal)),
      onPressed: onPressed);
}
