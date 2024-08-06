// import 'package:cura/components/Appbar.dart';
import 'package:hr_management_app/presentation/components/MyDrawer.dart';
import 'package:hr_management_app/presentation/components/TextFrom.dart';
import 'package:hr_management_app/presentation/components/Buttom.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr(3),
      appBar: customAppBar("نظام إدارة الموارد البشرية", context, false),
      drawer: MyDrawer(context),
      body: Center(
        child: Container(
          height: 360.0,
          width: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.0),
            color: clr(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 4,
                blurRadius: 4,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "إنشاء حساب",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      width: 350.0,
                      child: TextFrom(
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return "من فضلك أدخل كود المستخدم";
                          }
                          return null;
                        },
                        label: "كود المستخدم",
                        radius: 15.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      width: 350.0,
                      child: TextFrom(
                        obscure: true,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return "من فضلك أدخل كلمة السر";
                          }
                          return null;
                        },
                        label: "كلمة السر",
                        radius: 15.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {}, //Add later
                        child: Text(
                          "نسيت كلمة السر؟",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 45.0,
                        width: 60.0,
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Buttom(
                    width: 180.0,
                    text: "متابعة",
                    function: () {
                      if (formKey.currentState?.validate() ?? false) {}
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
