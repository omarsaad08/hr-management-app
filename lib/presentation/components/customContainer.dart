import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

Center customContainer(
    {required double width, required double height, required Widget child}) {
  return Center(
    child: Container(
      alignment: Alignment.center,
      width: Platform.isWindows ? width : double.infinity,
      height: Platform.isWindows ? height : double.infinity,
      padding: EdgeInsets.all(32),
      decoration:
          BoxDecoration(color: clr(4), borderRadius: BorderRadius.circular(32)),
      child: child,
    ),
  );
}
