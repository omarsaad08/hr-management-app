import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class TransactionsWebServices {
  late Dio dio;
  TransactionsWebServices() {
    dio = Dio();
  }
  // ================== new transaction ==================
  Future<dynamic> newTransaction(
      String transaction, Map<String, dynamic> data) async {
    try {
      final formData = json.encode(data);
      Response response = await dio
          .post('http://16.171.199.210:3000/$transaction', data: formData);
      if (response.statusCode == 200) {
        print('response ${response.data}');
        return response.data;
      } else {
        throw Exception('failed to add a transaction: ${response.data}');
      }
    } catch (e) {
      print(e);
      throw Exception('erorr: ${e}');
    }
  }
}
