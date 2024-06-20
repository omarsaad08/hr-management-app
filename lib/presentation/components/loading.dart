import 'package:flutter/material.dart';
// import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';

Center loading() {
  return customContainer(
      width: 600, height: 400, child: CircularProgressIndicator());
}
