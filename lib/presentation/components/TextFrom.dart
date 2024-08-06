import 'package:flutter/material.dart';

Widget TextFrom(
        {Function? validate,
        bool obscure = false,
        label,
        radius,
        controller}) =>
    TextFormField(
      controller: controller,
      validator: validate as String? Function(String?)?,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 15.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
