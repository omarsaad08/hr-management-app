import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class ArchiveWebServices {
  late Dio dio;
  ArchiveWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://localhost:3000/',
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    );
    dio = Dio();
  }

  Future<String> getDoc({required String id}) async {
    try {
      Response response = await dio.get('http://localhost:3000/archive/$id');
      print('data: ${response.data}');
      return response.data!;
    } catch (e) {
      throw Exception('failed to get the document');
    }
  }

  Future<List> getImages({required String doc, required String id}) async {
    try {
      Response response =
          await dio.get('http://localhost:3000/archive/$id/$doc');
      if (response.statusCode == 200) {
        print('got data, length: ${response.data.length}');
        for (var i = 0; i < response.data.length; i++) {
          Uint8List decodedData = base64Decode(response.data[i]['binary']);
          response.data[i]['binary'] = decodedData;
        }
        return response.data;
      } else {
        throw Exception('failed to get image');
      }
    } catch (e) {
      return [];
    }
  }

  Future<String> addUser({required String userId}) async {
    print('user id from web services: ${userId}');
    try {
      FormData formData = FormData.fromMap({
        'userId': userId,
      });
      Response response = await dio.post(
          'http://localhost:3000/archive/addUser',
          data: json.encode({'userId': userId}));
      return response.data;
    } catch (e) {
      print('error adding a user');
    }
    return 'error';
  }

  Future<String> postImage(
      {required String userId,
      required String filetype,
      required String filePath,
      required String filename}) async {
    try {
      FormData formData = FormData.fromMap({
        'userId': userId,
        'filetype': filetype,
        'file': await MultipartFile.fromFile(filePath, filename: filename),
      });
      Response response = await dio.post(
          'http://localhost:3000/archive/addToUserArchive',
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      return response.data;
    } catch (e) {
      print('error posting the image: $e');
    }
    return 'error';
  }
}
