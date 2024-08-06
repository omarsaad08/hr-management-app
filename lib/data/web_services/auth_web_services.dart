// not completed
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Dio dio = new Dio();
final storage = new FlutterSecureStorage();
String hostPath = 'http://localhost:3000';

class AuthWebServices {
  void signup(context, id, password, role, formKey) async {
    if (formKey.currentState?.validate() == true) {
      final data = json.encode(
          {'userId': id.text, 'password': password.text, 'role': role.text});
      try {
        Response response = await dio.post('${hostPath}/signup',
            data: data,
            options: Options(headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            }));
        final jwtToken =
            response.headers.value('set-cookie')!.split(';')[0].split('=');
        await storage.write(key: jwtToken[0], value: jwtToken[1]);
        print('token: ${jwtToken[1]}');
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<String?> login(id, password) async {
    final data = json.encode({"userId": id, "password": password});
    try {
      print('data: $data');
      Response response =
          await dio.post('http://16.171.199.210:3000/auth/login',
              data: data,
              options: Options(headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              }));
      final jwtToken =
          response.headers.value('set-cookie')!.split(';')[0].split('=');
      await storage.write(key: jwtToken[0], value: jwtToken[1]);
      return jwtToken[1];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> whoami(token) async {
    try {
      Response response = await dio.get(
          'http://16.171.199.210:3000/auth/whoheis',
          data: json.encode({"token": token}));

      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
