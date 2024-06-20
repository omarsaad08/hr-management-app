import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('الصفحة الرئيسية', context, false),
      body: Column(
        children: [
          customButton(label: 'المعاملات', onPressed: () {}),
          customButton(
              label: 'قاعدة البيانات',
              onPressed: () {
                Navigator.pushNamed(context, '/database_home');
              }),
          customButton(
              label: 'الأرشيف',
              onPressed: () {
                Navigator.pushNamed(context, '/archive_search');
              }),
        ],
      ),
    );
  }
}
