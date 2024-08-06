import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_app/data/web_services/requests_web_services.dart';
import 'package:hr_management_app/presentation/components/altButton.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class Requests extends StatefulWidget {
  Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final RequestsWebServices requestsWebServices = RequestsWebServices();
  File? file;

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      PlatformFile platformFile = result.files.first;
      File file = File(platformFile.path!);
      return file;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr(3),
      appBar: customAppBar('الطلبات', context, true),
      body: FutureBuilder(
        future: requestsWebServices.getAllRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              children: [Icon(Icons.close), Text("عذرا حدث خطأ")],
            ));
          } else if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: customContainer(
                      width: 1200,
                      height: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                  "نوع الطلب: ${snapshot.data![index]['requesttype']}",
                                  style: TextStyle(fontSize: 28)),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  "المحتوى: ${snapshot.data![index]['content']}")
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                  "رقم الطلب: ${snapshot.data![index]['requestid']}"),
                              Text(
                                  "تاريخ الطلب: ${snapshot.data![index]['dateofrequest'].toString().split('T')[0]}"),
                              Text(
                                  "كود الموظف: ${snapshot.data![index]['employeeid']}"),
                              Text(
                                  "حالة الطلب: ${snapshot.data![index]['status'] == 'pending' ? 'لا يوجد رد' : snapshot.data![index]['status']}")
                            ],
                          ),
                          !["مقبول", 'مرفوض']
                                  .contains(snapshot.data![index]['status'])
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    customButton(
                                        label: 'موافقة',
                                        onPressed: () {
                                          setState(() {
                                            requestsWebServices
                                                .updateRequestStatus(
                                                    snapshot.data![index]
                                                        ['requestid'],
                                                    'مقبول');
                                          });
                                        }),
                                    altButton(
                                        label: 'رفض',
                                        onPressed: () {
                                          setState(() {
                                            requestsWebServices
                                                .updateRequestStatus(
                                                    snapshot.data![index]
                                                        ['requestid'],
                                                    'مرفوض');
                                          });
                                        })
                                  ],
                                )
                              : snapshot.data![index]['status'] == 'مقبول' &&
                                      ['أجور متغيرة', 'مفردات مرتب'].contains(
                                          snapshot.data![index]['requesttype'])
                                  ? customButton(
                                      label: 'رفع ملف',
                                      onPressed: () async {
                                        file = await pickFile();
                                        if (file != null) {
                                          requestsWebServices.saveRequestFile(
                                              snapshot.data![index]['requestid']
                                                  .toString(),
                                              file!);
                                        }
                                      })
                                  : Container(),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: Text('لا يوجد طلبات'));
          }
        },
      ),
    );
  }
}
