import 'package:flutter/material.dart';
import 'package:hr_management_app/components/theme.dart';

Row customButton({
  required String label,
  required VoidCallback onPressed,
}) {
  return Row(
    children: [
      Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: clr(2),
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
            child: Text(label, style: TextStyle(color: clr(0), fontSize: 26)),
            onPressed: onPressed),
      ),
    ],
  );
}
