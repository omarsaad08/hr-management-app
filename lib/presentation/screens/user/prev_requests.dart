import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_app/business_logic/cubit/database_cubit.dart';
import 'package:hr_management_app/business_logic/pdf/database_files.dart';
import 'package:hr_management_app/data/web_services/database_web_services.dart';
import 'package:hr_management_app/data/web_services/requests_web_services.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class PrevRequests extends StatefulWidget {
  PrevRequests({super.key});

  @override
  State<PrevRequests> createState() => _PrevRequestsState();
}

class _PrevRequestsState extends State<PrevRequests> {
  RequestsWebServices requestsWebServices = RequestsWebServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr(5),
      appBar: customAppBar('الطلبات السابقة', context, true),
      body: FutureBuilder(
        future: requestsWebServices.getRequestsWithSameEmployee(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              children: [Icon(Icons.close), Text("عذرا حدث خطأ")],
            ));
          } else if (snapshot.hasData && snapshot.data != null) {
            final requestsData = snapshot.data!.reversed.toList();
            return ListView.builder(
                itemCount: requestsData.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16), color: clr(4)),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                              "نوع الطلب: ${requestsData[index]['requesttype']}",
                              style: TextStyle(fontSize: 22)),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Text("المحتوى: ${requestsData[index]['content']}"),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "رقم الطلب: ${requestsData[index]['requestid']}"),
                            Text(
                                "تاريخ الطلب: ${requestsData[index]['dateofrequest'].toString().split('T')[0]}"),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Text(
                              "حالة الطلب: ${requestsData[index]['status']}"),
                        ),
                        SizedBox(height: 8),
                        requestsData[index]['status'] == 'مقبول'
                            ? customButton(
                                label: 'تحميل الملف',
                                onPressed: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  final id =
                                      sharedPreferences.getString('userId');
                                  Map employeeInfo = {};
                                  if (id != null) {
                                    employeeInfo = await DatabaseWebServices()
                                        .getEmployee(id: id);
                                  } else {
                                    print("there is no id!");
                                  }
                                  if (requestsData[index]['requesttype'] ==
                                      'بيان حالة وظيفية') {
                                    DatabaseFiles.createEmployeeStatusFile(
                                        employeeInfo['employee']);
                                    // print('something');
                                  } else if (requestsData[index]
                                          ['requesttype'] ==
                                      'افادة') {
                                    Map data = employeeInfo['employee'];
                                    data['receiver'] =
                                        requestsData[index]['content'];
                                    DatabaseFiles.createStatement(data);
                                  } else if (['أجور متغيرة', 'مفردات مرتب']
                                      .contains(
                                          requestsData[index]['requesttype'])) {
                                    final data = await requestsWebServices
                                        .getRequestFile(requestsData[index]
                                                ['requestid']
                                            .toString());
                                  }
                                })
                            : Container(),
                      ],
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
