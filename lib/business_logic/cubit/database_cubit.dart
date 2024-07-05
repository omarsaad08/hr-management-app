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
      print('data: $data');
      emit(DatabaseAddedEmployee(data: data));
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

  // ===================== PDF Generation =====================
  void pdfTemplate(PdfPageFormat pageFormate, pw.Widget data) async {
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("fonts/Cairo.ttf")),
    );
    final pdf = pw.Document(theme: myTheme);
    pdf.addPage(pw.Page(
        pageFormat: pageFormate,
        build: (pw.Context Context) {
          return pw.Directionality(
              textDirection: pw.TextDirection.rtl, child: data);
        }));
    Uint8List byteList = await pdf.save();
    var filePath = './test.pdf';
    final file = File(filePath);
    await file.writeAsBytes(byteList);
  }

  void createEmployeeStatusFile(Map employeeInfo) async {
    // Load image from assets
    final ByteData bytes = await rootBundle.load('images/faisal-logo.png');
    final Uint8List imageData = bytes.buffer.asUint8List();
    pw.TextStyle style = pw.TextStyle(fontSize: 15);
    pdfTemplate(
        PdfPageFormat.a4.portrait,
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(children: [
                  pw.Text('محافظة السويس'),
                  pw.Text('رئاسة حي فيصل'),
                  pw.Text('إدارة الموارد البشرية'),
                  pw.Text('---------------------')
                ]),
                pw.Image(pw.MemoryImage(imageData), width: 100, height: 100),
              ]),
          pw.SizedBox(height: 16),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#e9ebf8'),
                  border: pw.Border.all(color: PdfColors.black, width: 1)),
              child: pw.Text('بيان حالة وظيفية',
                  style: pw.TextStyle(fontSize: 18)),
            )
          ]),
          pw.SizedBox(
            height: 16,
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Container(
                margin: pw.EdgeInsets.only(bottom: 8),
                padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#e9ebf8'),
                    border: pw.Border.all(color: PdfColors.black, width: 1),
                    borderRadius: pw.BorderRadius.circular(8)),
                child:
                    pw.Text('بيانات شخصية', style: pw.TextStyle(fontSize: 16)),
              )
            ],
          ),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['nationalidnumber']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('الرقم القومي'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['name']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('الإسم'),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['address']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('العنوان'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['degree']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('المؤهل'),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Container(
                margin: pw.EdgeInsets.only(bottom: 8),
                padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#e9ebf8'),
                    border: pw.Border.all(color: PdfColors.black, width: 1),
                    borderRadius: pw.BorderRadius.circular(8)),
                child:
                    pw.Text('بيانات وظيفية', style: pw.TextStyle(fontSize: 16)),
              )
            ],
          ),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['dateofappointment']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('تاريخ استلام العمل'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['contractdate']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('تاريخ التعيين / التعاقد'),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['jobcategory']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('المجموعة النوعية'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['functionalgroup']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('المجموعة الوظيفية'),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['jobtitle']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('المسمى الوظيفي'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['degree']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('الدرجة الوظيفية'),
                  ),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('لا يوجد'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('الجزاءات'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('${employeeInfo['report']}'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Text('التقرير'),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('مدير الموارد البشرية',
                  style: pw.TextStyle(fontSize: 20)),
              pw.Text('يعتمد')
            ],
          )
        ]));
  }

  void createStatistics(List<Map> filteredEmployees) async {
    pdfTemplate(
        PdfPageFormat.a4.landscape,
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('بيان احصائي', style: pw.TextStyle(fontSize: 18)),
          pw.TableHelper.fromTextArray(
            headers: filteredEmployees[0].keys.toList(),
            data: filteredEmployees.map((map) => map.values.toList()).toList(),
          )
        ]));
  }
}
