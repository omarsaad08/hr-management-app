import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:file_saver/file_saver.dart';
import 'package:open_file/open_file.dart';

class DatabaseFiles {
  // ===================== PDF Generation =====================
  static void pdfTemplate(PdfPageFormat pageFormate, pw.Widget data) async {
    var myTheme = pw.ThemeData.withFont(
        base: pw.Font.ttf(await rootBundle.load("fonts/NotoNaskhArabic.ttf")),
        fontFallback: [pw.Font.times(), pw.Font.helvetica()]);
    final pdf = pw.Document(theme: myTheme);
    pdf.addPage(pw.Page(
        pageFormat: pageFormate,
        build: (pw.Context Context) {
          return pw.Directionality(
              textDirection: pw.TextDirection.rtl, child: data);
        }));
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/example.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
  }

  static void createEmployeeStatusFile(Map employeeInfo) async {
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

  static void createStatistics(
      List<Map<String, dynamic>> filteredEmployees) async {
    final ByteData bytes = await rootBundle.load('images/faisal-logo.png');
    final Uint8List imageData = bytes.buffer.asUint8List();
    List<Map> numbers = List.generate(
        filteredEmployees.length, (int index) => {"م": index + 1});

    for (int i = 0; i < filteredEmployees.length; i++) {
      // numbers[i].addAll({"م": i + 1});
      // numbers[i].addAll(filteredEmployees[i]);
      numbers[i].addAll(filteredEmployees[i]);
      if (i == 0) {
        print(numbers[i]);
      }
    }
    pdfTemplate(
        PdfPageFormat.a4.landscape,
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
          pw.Text('بيان احصائي', style: pw.TextStyle(fontSize: 14)),
          pw.TableHelper.fromTextArray(
            cellPadding: pw.EdgeInsets.all(2),
            cellAlignment: pw.Alignment.center,
            headers: numbers[0].keys.toList().reversed.toList(),
            data: numbers
                .map((map) => map.values.toList().reversed.toList())
                .toList(),
          )
        ]));
  }

  static void createStatement(Map data) async {
    final ByteData bytes = await rootBundle.load('images/faisal-logo.png');
    final Uint8List imageData = bytes.buffer.asUint8List();
    final style = pw.TextStyle(fontSize: 18);
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
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [pw.Text('افادة', style: style)]),
          pw.SizedBox(height: 8),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Text('السيد/ة: ${data['receiver']}, تحية طيبة وبعد...',
                style: style),
          ]),
          pw.SizedBox(height: 8),
          pw.Text('نحيط سيادتكم علما بأن السيد/ة: ${data['name']}',
              style: style),
          pw.Text('رقم قومي: ${data['nationalidnumber']}', style: style),
          pw.SizedBox(height: 8),
          pw.Text(
              'من العاملين بديوان عام حي فيصل بإدارة: ${data['administration']}',
              style: style),
          pw.SizedBox(height: 8),
          pw.Text(
              'ومازال بالعمل حتى تاريخه: ${DateTime.now().toString().split(' ')[0]}',
              style: style),
          pw.SizedBox(height: 8),
          pw.Text(
              'وقد اعطيت هذه الافادة بناءا على طلبه دون أدنى مسئولية على الحي.',
              style: style),
          pw.SizedBox(height: 8),
          pw.Text('وتفضلوا بقبول فائق الاحترام.', style: style),
          pw.SizedBox(height: 16),
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
}
