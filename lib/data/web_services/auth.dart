import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Dio dio = new Dio();
final storage = new FlutterSecureStorage();
String hostPath = 'http://localhost:3000/';

void signup(context, id, password, role, formKey) async {
  if (formKey.currentState?.validate() == true) {
    final data = json.encode(
        {'userId': id.text, 'password': password.text, 'role': role.text});
    try {
      Response response = await dio.post('${hostPath}signup',
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          }));
      final jwtToken =
          response.headers.value('set-cookie')!.split(';')[0].split('=');
      await storage.write(key: jwtToken[0], value: jwtToken[1]);
      print('token: ${jwtToken[1]}');
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      print('Error: $e');
    }
  }
}

void login(context, id, password, formKey) {}
void checkAuth(token) {}
