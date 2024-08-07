import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/database_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHome extends StatefulWidget {
  DatabaseHome({super.key});

  @override
  State<DatabaseHome> createState() => _DatabaseHomeState();
}

class _DatabaseHomeState extends State<DatabaseHome> {
  Map arabicToEnglishDataNames = {
    'ID': 'employeeid',
    'الاسم': 'name',
    'الرقم القومي': 'nationalidnumber',
    'الادارة': 'administration',
    'المسمى الوظيفي': 'jobtitle',
    'الدرجة الوظيفية': 'degree',
    'المجموعة الوظيفية': 'functionalgroup',
    'المؤهل': 'qualification',
    'تاريخ استلام العمل': 'dateofappointment',
    'العنوان': 'address',
    'الرقم التأميني': 'insurancenumber',
    'تاريخ التعيين / التعاقد': 'contractdate',
    'تاريخ اخر ترقية': 'dateoflastpromotion',
    'الديانة': 'religion',
    'تاريخ الميلاد': 'date_of_birth',
    'النوع': 'gender',
    'رقم الهاتف': 'phone_number',
    'الحالة من التجنيد': 'military_service_status',
    'المجموعة النوعية': 'jobcategory',
    'الوظيفة الحالية': 'currentjob',
    'نوع العقد': 'typeofcontract',
    'اخر تقرير': 'report',
    'الحالة من العمل': 'employmentstatus',
  };
  TextEditingController deleteController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController employeeStatusFileIdController =
      TextEditingController();
  TextEditingController statisticsController = TextEditingController();
  TextEditingController employeeStatusFileDataController =
      TextEditingController();
  // === build employee status file ===
  void buildEmployeeStatusFile(String type, List data) {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text(type),
          content: customTextField(
              controller: employeeStatusFileIdController, label: 'كود الموظف'),
          actions: [
            type == 'افادة'
                ? customTextField(
                    controller: employeeStatusFileDataController,
                    label: 'الجهة')
                : Container(),
            TextButton(
              onPressed: () {
                if (employeeStatusFileIdController.text != '') {
                  Map employeeData = data.where((item) {
                    return item['employeeid']
                        .toString()
                        .contains(employeeStatusFileIdController.text);
                  }).toList()[0];
                  if (type == 'بيان حالة وظيفية') {
                    context
                        .read<DatabaseCubit>()
                        .createEmployeeStatusFile(employeeData as Map);
                  } else if (type == 'افادة') {
                    employeeData['receiver'] =
                        employeeStatusFileDataController.text;
                    context
                        .read<DatabaseCubit>()
                        .createStatement(employeeData as Map);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('إنشاء'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      context.read<DatabaseCubit>().filterEmployees(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> columns = [];
    arabicToEnglishDataNames.keys.forEach(
      (element) {
        columns.add(DataColumn(
            label: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: clr(2), borderRadius: BorderRadius.circular(8)),
          child: Text(
            element,
            style: TextStyle(color: clr(5)),
          ),
        )));
      },
    );
    List<DataCell> createRow(Map item) {
      List<DataCell> row = [];
      arabicToEnglishDataNames.values.forEach((element) {
        if (element != "employeeid") {
          row.add(DataCell(Text(item[element].toString())));
        } else {
          row.add(DataCell(
              Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: clr(2), borderRadius: BorderRadius.circular(8)),
                  child: Text(item[element].toString(),
                      style: TextStyle(color: clr(5)))), onTap: () {
            Navigator.pushNamed(context, '/employee_details',
                arguments: item[element]);
          }));
        }
      });
      return row;
    }

    return Scaffold(
        backgroundColor: clr(4),
        appBar: customAppBar('قاعدة البيانات', context, true),
        body: BlocBuilder<DatabaseCubit, DatabaseState>(
          builder: (context, state) {
            if (state is DatabaseEmployeesLoaded) {
              return Container(
                margin: EdgeInsets.all(4),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Wrap(
                        runSpacing: 12,
                        children: [
                          IconButton(
                              onPressed: () {
                                context.read<DatabaseCubit>().getAllemployees();
                              },
                              icon: Icon(Icons.refresh)),
                          SizedBox(width: 16),
                          // add an employee
                          customButton(
                              label: 'إضافة موظف',
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/database_add_employee');
                              }),

                          SizedBox(width: 16),
                          // update an employee
                          customButton(
                              label: 'تعديل موظف',
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/database_update_employee');
                              }),
                          SizedBox(width: 16),

                          // delete an employee
                          Container(
                            width: 256,
                            child: customTextField(
                                controller: deleteController,
                                label: 'حذف موظف',
                                icon: true,
                                fieldIcon: Icon(Icons.delete)),
                          ),
                          SizedBox(width: 16),
                          customButton(
                              label: 'حذف',
                              onPressed: () {
                                context
                                    .read<DatabaseCubit>()
                                    .deleteEmployee(id: deleteController.text);
                                deleteController.text = '';
                              }),

                          SizedBox(width: 16),

                          // search an employee
                          Container(
                            width: 256,
                            child: customTextField(
                                controller: searchController,
                                label: 'بحث موظف',
                                icon: true,
                                fieldIcon: Icon(Icons.search)),
                          ),

                          SizedBox(width: 16),

                          // employee status generation
                          customButton(
                              label: 'بيان حالة وظيفية',
                              onPressed: () {
                                buildEmployeeStatusFile(
                                    'بيان حالة وظيفية', state.data);
                              }),
                          SizedBox(width: 16),
                          // employee status generation
                          customButton(
                              label: 'افادة',
                              onPressed: () {
                                buildEmployeeStatusFile('افادة', state.data);
                              }),
                          SizedBox(width: 16),
                          // statistics generation
                          customButton(
                              label: 'إحصائية',
                              onPressed: () {
                                // makeStatistics(state.data);
                                Navigator.pushNamed(
                                    context, '/database_statistics',
                                    arguments: state.data);
                              })
                        ],
                      ),
                    ),
                    Row(
                      children: [],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: TableBorder.all(color: clr(3), width: 1),
                        columns: columns,
                        rows: state.data.map((item) {
                          item['dateofappointment'] = item['dateofappointment']
                              .toString()
                              .split('T')[0];
                          item['contractdate'] =
                              item['contractdate'].toString().split('T')[0];
                          item['dateoflastpromotion'] =
                              item['dateoflastpromotion']
                                  .toString()
                                  .split('T')[0];
                          item['date_of_birth'] =
                              item['date_of_birth'].toString().split('T')[0];
                          return DataRow(
                            cells: createRow(item),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              context.read<DatabaseCubit>().getAllemployees();
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
