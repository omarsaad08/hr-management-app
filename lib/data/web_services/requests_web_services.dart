import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsWebServices {
  final String baseURL = "http://16.171.199.210:3000";
  // final String baseURL = "http://localhost:3000";
  final Dio dio = Dio();
  Future<List?> getAllRequests() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final role = sharedPreferences.getString('role');
    try {
      Response response = await dio.get('$baseURL/requests');
      List data = [];
      print('role: $role');
      for (Map request in response.data) {
        request['receiver_role'] == role
            ? data.add(request)
            : print(
                'out: ${request}, receiver role: ${request['receiver_role']}');
        request['receiver_role'] == role ? print('in: $request') : null;
      }
      return data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map?> getRequest(String id) async {
    try {
      Response response = await dio.get('$baseURL/requests/$id');
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map?> updateRequestStatus(dynamic id, String status) async {
    try {
      final data = {"status": status};
      Response response = await dio.patch('$baseURL/requests/$id/status',
          data: json.encode(data));
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map?> updateRequestReceiver(dynamic id, String receiver) async {
    try {
      final data = {"receiver_role": receiver};
      Response response = await dio.patch('$baseURL/requests/$id/receiver_role',
          data: json.encode(data));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List?> getRequestsWithSameType(String type) async {
    try {
      Response response = await dio.get('$baseURL/requests/type/$type');
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List?> getRequestsWithSameEmployee() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getString('userId');
    try {
      Response response = await dio.get('$baseURL/requests/employee/$id');
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List?> getRequestsWithSameStatus(String status) async {
    try {
      Response response = await dio.get('$baseURL/requests/status/$status');
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int?> makeRequest(Map data) async {
    try {
      Response response =
          await dio.post('$baseURL/requests', data: json.encode(data));
      return response.data;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<Map?> deleteRequest(String id) async {
    try {
      Response response = await dio.delete('$baseURL/requests/$id');
      return response.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveRequestFile(String id, File file) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: 'test'),
      });
      Response response = await dio.post(
          'http://localhost:3000/requestsArchive/$id',
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getRequestFile(String id) async {
    try {
      Response response =
          await dio.get('http://192.168.1.219:3000/requestsArchive/$id');
      Uint8List decodedData = base64Decode(response.data['base64']);
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/example.pdf');
      await file.writeAsBytes(decodedData);
      OpenFile.open(file.path);
      return file;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
