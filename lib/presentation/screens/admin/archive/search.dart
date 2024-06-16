import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class ArchiveSearch extends StatefulWidget {
  const ArchiveSearch({super.key});

  @override
  State<ArchiveSearch> createState() => _ArchiveSearchState();
}

class _ArchiveSearchState extends State<ArchiveSearch> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr(3),
      appBar: customAppBar('الأرشيف'),
      body: Center(
        child: Container(
          width: 600,
          height: 400,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
              color: clr(4), borderRadius: BorderRadius.circular(32)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "أدخل كود الموظف",
                style: TextStyle(fontSize: 36),
              ),
              SizedBox(
                height: 20,
              ),
              customTextField(controller: idController, label: 'كود الموظف'),
              SizedBox(
                height: 20,
              ),
              customButton(
                  label: 'متابعة',
                  onPressed: () {
                    Navigator.pushNamed(context, '/user_archive');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
