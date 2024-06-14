import 'package:flutter/material.dart';
import 'package:hr_management_app/services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

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
                  SizedBox(height: 40),
                  ElevatedButton(
                    child: Text('إنشاء حساب'),
                    onPressed: () {
                      login(context, _idController, _passwordController,
                          _formKey);
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
