import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class EmployeeDetails extends StatefulWidget {
  final int id;
  EmployeeDetails({super.key, required this.id});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  Future<Map?> getEmployee() async {
    Response response = await Dio()
        .get("http://16.171.199.210:3000/employees/Details/${widget.id}");
    return response.data;
  }

  Widget buildInfoCard(String label, String value) {
    return Card(
      color: clr(5),
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 8.0),
            Text(
                value == null || value == '' || value == 'null'
                    ? 'لا يوجد'
                    : value,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...children,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr(4),
      appBar: customAppBar('بيانات الموظف ${widget.id}', context, true),
      body: FutureBuilder(
        future: getEmployee(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var employee = snapshot.data!["employee"];
            var requests = snapshot.data!["requests"];
            var increasements = snapshot.data!["increasements"];
            var trainings = snapshot.data!["trainings"];
            var penalties = snapshot.data!["penalties"];
            var vacations = snapshot.data!["vacations"];
            var promotions = snapshot.data!["promotions"];
            var assignments = snapshot.data!["assignments"];

            return ListView(
              // padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  color: clr(4),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المعلومات الشخصية',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 24,
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          childAspectRatio: 3,
                          children: [
                            buildInfoCard('كود الموظف',
                                employee['employeeid'].toString()),
                            buildInfoCard('اسم', employee['name']),
                            buildInfoCard(
                                'الرقم القومي', employee['nationalidnumber']),
                            buildInfoCard(
                                'تاريخ التعيين',
                                employee['dateofappointment']
                                    .toString()
                                    .split('T')[0]),
                            buildInfoCard(
                                'رقم التأمين', employee['insurancenumber']),
                            buildInfoCard(
                                'تاريخ العقد',
                                employee['contractdate']
                                    .toString()
                                    .split('T')[0]),
                            buildInfoCard('المجموعة الوظيفية',
                                employee['functionalgroup']),
                            buildInfoCard(
                                'المسمى الوظيفي', employee['jobtitle']),
                            buildInfoCard('الدرجة', employee['degree']),
                            buildInfoCard('العنوان', employee['address']),
                            buildInfoCard(
                                'تاريخ الترقية الأخيرة',
                                employee['dateoflastpromotion']
                                    .toString()
                                    .split('T')[0]),
                            buildInfoCard('الدور', employee['role']),
                            buildInfoCard('الجنس', employee['gender']),
                            buildInfoCard('الديانة', employee['religion']),
                            buildInfoCard(
                                'تاريخ الميلاد',
                                employee['date_of_birth']
                                    .toString()
                                    .split('T')[0]),
                            buildInfoCard(
                                'رقم الهاتف', employee['phone_number']),
                            buildInfoCard('حالة الخدمة العسكرية',
                                employee['military_service_status']),
                            buildInfoCard(
                                'فئة الوظيفة', employee['jobcategory']),
                            buildInfoCard(
                                'الإدارة', employee['administration']),
                            buildInfoCard(
                                'الوظيفة الحالية', employee['currentjob']),
                            buildInfoCard('المؤهل', employee['qualification']),
                            buildInfoCard(
                                'نوع العقد', employee['typeofcontract']),
                            buildInfoCard('تقرير', employee['report']),
                            buildInfoCard(
                                'حالة التوظيف', employee['employmentstatus']),
                            buildInfoCard('الحالة الاجتماعية',
                                employee['maritalstatus'] ?? 'غير متاح'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (requests.isNotEmpty)
                  buildSection(
                      'الطلبات',
                      requests.map<Widget>((request) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: ListTile(
                            title: Text(request['requesttype']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('الى: ${request['receiver_role']}'),
                                Text('المحتوى: ${request['content']}'),
                                Text('الحالة: ${request['status']}'),
                                Text(
                                    'تاريخ الطلب: ${request['dateofrequest'].toString().split('T')[0]}'),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                if (increasements.isNotEmpty)
                  buildSection(
                      'الزيادات',
                      increasements.map<Widget>((increasement) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: ListTile(
                            title: Text('زيادة ${increasement['type']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('التاريخ: ${increasement['date']}'),
                                Text('النسبة: ${increasement['percentage']}%'),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                if (trainings.isNotEmpty)
                  buildSection(
                      'التدريبات',
                      trainings.map<Widget>((training) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: ListTile(
                            title: Text(training['training_name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('تاريخ البدء: ${training['start_date']}'),
                                Text('تاريخ الانتهاء: ${training['end_date']}'),
                                Text('المكان: ${training['location']}'),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                if (penalties.isNotEmpty)
                  buildSection(
                      'العقوبات',
                      penalties.map<Widget>((penalty) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: ListTile(
                            title: Text('عقوبة ${penalty['type']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('التاريخ: ${penalty['date']}'),
                                Text('الوصف: ${penalty['description']}'),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                if (vacations.isNotEmpty)
                  buildSection(
                      'الإجازات',
                      vacations.map<Widget>((vacation) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: ListTile(
                            title: Text('إجازة ${vacation['type']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('تاريخ البدء: ${vacation['start_date']}'),
                                Text('تاريخ الانتهاء: ${vacation['end_date']}'),
                                Text('الوصف: ${vacation['description']}'),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                if (promotions.isNotEmpty)
                  buildSection(
                      'الترقيات',
                      promotions.map<Widget>((promotion) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: ListTile(
                            title: Text('ترقية ${promotion['title']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('التاريخ: ${promotion['date']}'),
                                Text('الوصف: ${promotion['description']}'),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                if (assignments.isNotEmpty)
                  buildSection(
                      'التكليفات',
                      assignments.map<Widget>((assignment) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: ListTile(
                            title: Text('تكليف ${assignment['title']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('التاريخ: ${assignment['date']}'),
                                Text('الوصف: ${assignment['description']}'),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
              ],
            );
          } else {
            return Center(child: Text('لا توجد بيانات'));
          }
        },
      ),
    );
  }
}
