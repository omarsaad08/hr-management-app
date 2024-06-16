import 'package:flutter/material.dart';
import 'package:hr_management_app/data/web_services/auth.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(labelText: "كود الموظف"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'كلمة المرور'),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _roleController,
                    decoration: InputDecoration(labelText: 'المستوى'),
                    obscureText: true,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    child: Text('إنشاء حساب'),
                    onPressed: () {
                      signup(context, _idController, _passwordController,
                          _roleController, _formKey);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
