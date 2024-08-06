// import 'package:cura/components/Appbar.dart';
import 'dart:io';

import 'package:hr_management_app/data/web_services/database_web_services.dart';
import 'package:hr_management_app/presentation/components/MyDrawer.dart';
import 'package:hr_management_app/presentation/components/TextFrom.dart';
import 'package:hr_management_app/presentation/components/Buttom.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:hr_management_app/data/web_services/auth_web_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var formKey = GlobalKey<FormState>();
  final AuthWebServices auth = AuthWebServices();
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: clr(3),
        appBar: customAppBar("نظام إدارة الموارد البشرية", context, false),
        drawer: MyDrawer(context),
        body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              List<ConnectivityResult> connectivity,
              Widget child,
            ) {
              final bool connected =
                  !connectivity.contains(ConnectivityResult.none);
              return new Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    height: connected ? 0 : 24,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                      child: Center(
                        child:
                            Text("${connected ? 'ONLINE' : 'لا يوجد انترنت'}"),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 400.0,
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
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "تسجيل الدخول",
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
                                      controller: idController),
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
                                      controller: passwordController),
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
                                function: () async {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    final token = await auth.login(
                                        idController.text,
                                        passwordController.text);
                                    if (token != null) {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      await sharedPreferences.setString(
                                          'userId', idController.text);
                                      final employeeData =
                                          await DatabaseWebServices()
                                              .getEmployee(
                                                  id: idController.text);
                                      await sharedPreferences.setString("role",
                                          employeeData["employee"]["role"]);
                                      if (employeeData["employee"]["role"]
                                                  .toString() ==
                                              "الموارد البشرية" &&
                                          Platform.isWindows) {
                                        Navigator.pushNamed(
                                            context, '/admin_home');
                                      } else if (employeeData["employee"]
                                                  ["role"]
                                              .toString()
                                              .contains("مدير") ||
                                          employeeData["employee"]["role"]
                                              .toString()
                                              .contains("الحي")) {
                                        Navigator.pushNamed(
                                            context, '/head_home');
                                      } else {
                                        Navigator.pushNamed(
                                            context, '/user_home');
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('خطأ'),
                                            content: Text(
                                                'كود المستخدم او كلمة المرور خطأ'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            child: Center()));
  }
}
