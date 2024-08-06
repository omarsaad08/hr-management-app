import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:hr_management_app/data/web_services/requests_web_services.dart';
import 'package:hr_management_app/presentation/components/altButton.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeadRequests extends StatefulWidget {
  const HeadRequests({super.key});

  @override
  State<HeadRequests> createState() => _HeadRequestsState();
}

class _HeadRequestsState extends State<HeadRequests> {
  final RequestsWebServices requestsWebServices = RequestsWebServices();

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
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    color: clr(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                                "نوع الطلب: ${snapshot.data![index]['requesttype']}",
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text("المحتوى: ${snapshot.data![index]['content']}")
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                "رقم الطلب: ${snapshot.data![index]['requestid']}"),
                            Text(
                                "تاريخ الطلب: ${snapshot.data![index]['dateofrequest'].toString().split('T')[0]}"),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                "كود الموظف: ${snapshot.data![index]['employeeid']}"),
                            Text(
                                "حالة الطلب: ${snapshot.data![index]['status'] == 'pending' ? 'لا يوجد رد' : snapshot.data![index]['status']}")
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        !["مقبول", 'مرفوض']
                                .contains(snapshot.data![index]['status'])
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  customButton(
                                      label: 'موافقة',
                                      onPressed: () async {
                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();
                                        final role =
                                            sharedPreferences.getString("role");
                                        setState(() {
                                          if (role!.contains('الحي')) {
                                            requestsWebServices
                                                .updateRequestStatus(
                                                    snapshot.data![index]
                                                        ['requestid'],
                                                    'مقبول');
                                          } else {
                                            requestsWebServices
                                                .updateRequestReceiver(
                                                    snapshot.data![index]
                                                        ['requestid'],
                                                    'الموارد البشرية');
                                          }
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
