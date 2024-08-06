import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_management_app/data/web_services/database_web_services.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../pdf/database_files.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseWebServices databaseWebServices;
  DatabaseCubit({required this.databaseWebServices}) : super(DatabaseInitial());
  List filteredData = [];
  List data = [];
  void addEmployeeInitial() {
    emit(DatabaseAddEmployeeInitial());
  }

  void getAllemployees() async {
    emit(DatabaseEmployeesLoading());
    try {
      data = await databaseWebServices.getAllEmployees();
      filteredData = data;
      emit(DatabaseEmployeesLoaded(data: data));
    } catch (e) {
      emit(DatabaseGettingEmployeesError(
          message: 'fetching employees failed: $e'));
    }
  }

  void filterEmployees(String query) {
    filteredData = data.where((item) {
      return item['employeeid'].toString().contains(query) ||
          item['name'].toString().contains(query);
    }).toList();
    emit(DatabaseEmployeesLoaded(data: filteredData));
  }

  void getEmployee({required String id}) async {
    emit(DatabaseEmployeeLoading());
    try {
      final data = await databaseWebServices.getEmployee(id: id);
      emit(DatabaseEmployeeLoaded(data: data));
    } catch (e) {
      emit(DatabaseGettingEmployeeError(
          message: 'fetching employee failed: $e'));
    }
  }

  Future<void> addEmployee({required Map<String, dynamic> employeeData}) async {
    emit(DatabaseAddingEmployee());

    try {
      final data =
          await databaseWebServices.addEmployee(employeeData: employeeData);
      print('${data} ${employeeData['nationalidnumber']}');
      signupEmployee(data.toString(), employeeData['nationalidnumber']);
    } catch (e) {
      emit(DatabaseAddingEmployeeError(message: '$e'));
    }
  }

  Future<void> signupEmployee(String id, String nationalidnumber) async {
    try {
      final signupResponse =
          await databaseWebServices.signupEmployee(id, nationalidnumber);
      print(signupResponse);
      emit(DatabaseAddedEmployee());
    } catch (e) {
      emit(DatabaseAddingEmployeeError(message: '$e'));
    }
  }

  Future<void> updateEmployee(
      {required Map<String, dynamic> employeeData}) async {
    emit(DatabaseAddingEmployee());

    try {
      final data =
          await databaseWebServices.updateEmployee(employeeData: employeeData);
      print('data: $data');
      emit(DatabaseAddedEmployee());
    } catch (e) {
      emit(DatabaseAddingEmployeeError(message: '$e'));
    }
  }

  void deleteEmployee({required String id}) async {
    emit(DatabaseDeletingEmployee());
    try {
      final data = await databaseWebServices.deleteEmployee(id: id);
      emit(DatabaseDeletedEmployee(data: data));
    } catch (e) {
      emit(DatabaseDeletingEmployeeError(message: '$e'));
    }
  }

  void createEmployeeStatusFile(Map employeeInfo) {
    DatabaseFiles.createEmployeeStatusFile(employeeInfo);
  }

  void createStatistics(List<Map<String, dynamic>> filteredEmployees) {
    DatabaseFiles.createStatistics(filteredEmployees);
  }

  void createStatement(Map data) {
    DatabaseFiles.createStatement(data);
  }
}
