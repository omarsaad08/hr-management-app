// use this app bar in the screens that has an app bar
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

AppBar customAppBar(String title) {
  return AppBar(
    elevation: 10,
    backgroundColor: clr(1),
    leading: IconButton(
      color: clr(2),
      icon: Icon(
        Icons.settings,
        size: 32,
      ),
      onPressed: () {
        // for later: this should navigate to the settings screen
      },
    ),
    title: Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 26),
    ),
    centerTitle: true,
  );
}
