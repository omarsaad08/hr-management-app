import 'dart:convert';

import 'package:dio/dio.dart';

class UserWebServices {
  late Dio dio;
  final baseURL = 'http://16.171.199.210:3000';
  UserWebServices() {
    dio = Dio();
  }

  Future<dynamic> makeRequest(Map data) async {
    try {
      Response response = await dio.post('$baseURL/requests', data: json.encode(data));
    } catch (e) {
      print(e);
    }
  }
} 