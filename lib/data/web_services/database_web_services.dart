import 'package:dio/dio.dart';
import 'dart:convert';

class DatabaseWebServices {
  late Dio dio;
  DatabaseWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://16.171.199.210:3000',
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    );
    dio = Dio();
  }

  Future<List> getAllEmployees() async {
    try {
      Response response = await dio.get('http://16.171.199.210:3000/employees');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('failed to get employess');
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map> getEmployee({required String id}) async {
    try {
      Response response =
          await dio.get('http://16.171.199.210:3000/employees/Details/$id');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('failed to find that employee');
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<dynamic> addEmployee(
      {required Map<String, dynamic> employeeData}) async {
    try {
      final data = json.encode(employeeData);
      Response response =
          await dio.post('http://16.171.199.210:3000/employees', data: data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('failed to add employee');
      }
    } catch (e) {
      return "error: $e";
    }
  }

  Future<dynamic> signupEmployee(String id, String nationalidnumber) async {
    final data = {"userId": id, "password": nationalidnumber};
    try {
      Response response = await dio.post('http://localhost:3000/auth/signup',
          data: json.encode(data));
      return response.data;
    } catch (e) {
      return "error: $e";
    }
  }

  Future<String> updateEmployee(
      {required Map<String, dynamic> employeeData}) async {
    try {
      var id = employeeData['employeeid'];
      employeeData.remove('employeeid');
      final data = json.encode(employeeData);
      Response response =
          await dio.put('http://16.171.199.210:3000/employees/$id', data: data);
      if (response.statusCode == 200) {
        return "employee's data updated successfuly";
      } else {
        throw Exception('failed to update employee data');
      }
    } catch (e) {
      return "error: $e";
    }
  }

  Future<String> deleteEmployee({required String id}) async {
    try {
      Response response =
          await dio.delete('http://16.171.199.210:3000/employees/$id');
      if (response.statusCode == 200) {
        return "employee deleted Successfuly";
      } else {
        throw Exception('failed to delete the employee');
      }
    } catch (e) {
      return "error: $e";
    }
  }
}
