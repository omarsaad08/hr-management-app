import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

Widget Buttom(
        {required width,
        required VoidCallback function,
        required String text}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: function, //Add later
        style: TextButton.styleFrom(
          backgroundColor: clr(2),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
