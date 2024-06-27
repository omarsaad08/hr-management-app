// use this app bar in the screens that has an app bar
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

AppBar customAppBar(String title, context, bool showLeading,
    {VoidCallback? onPop}) {
  return AppBar(
    elevation: 10,
    backgroundColor: clr(1),
    leading: showLeading
        ? IconButton(
            color: clr(2),
            icon: Icon(
              Icons.arrow_back,
              size: 32,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                if (onPop != null) {
                  onPop();
                }
                Navigator.pop(context);
              }
            },
          )
        : null,
    title: Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 26),
    ),
    centerTitle: true,
  );
}
