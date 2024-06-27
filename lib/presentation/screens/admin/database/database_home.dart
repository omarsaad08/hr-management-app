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
  const DatabaseHome({super.key});

  @override
  State<DatabaseHome> createState() => _DatabaseHomeState();
}

class _DatabaseHomeState extends State<DatabaseHome> {
  Map arabicToEnglishDataNames = {
    'ID': 'ID',
    'الاسم': 'name',
    'الرقم القومي': 'nationalidnumber',
    'تاريخ التعيين': 'dateofappointment',
    'الرقم التأميني': 'insurancenumber',
    'تاريه التعاقد': 'contractdate',
    'المجموعة الوظيفية': 'functionalgroup',
    'المسمى الوظيفي': 'jobtitle',
    'المؤهل': 'degree',
    'العنوان': 'address',
    'dateoflastpromotion': 'تاريخ اخر ترقية'
  };
  TextEditingController deleteController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController employeeStatusFileIdController =
      TextEditingController();
  TextEditingController statisticsController = TextEditingController();
  // === build employee status file ===
  void buildEmployeeStatusFile(List data) {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text('بيان حالة وظيفية'),
          content: customTextField(
              controller: employeeStatusFileIdController, label: 'كود الموظف'),
          actions: [
            TextButton(
              onPressed: () {
                if (employeeStatusFileIdController.text != '') {
                  Map employeeData = data.where((item) {
                    return item['employeeid']
                        .toString()
                        .contains(employeeStatusFileIdController.text);
                  }).toList()[0];
                  context
                      .read<DatabaseCubit>()
                      .createEmployeeStatusFile(employeeData as Map);
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

  // === make statistics === //
  void makeStatistics(List data) {
    String selectedItem = 'تاريخ التعيين';
    List wantedItems = [];
    List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(value: 'تاريخ التعيين', child: Text('تاريخ التعيين')),
      DropdownMenuItem(value: 'تاريخ التعاقد', child: Text('تاريخ التعاقد')),
      DropdownMenuItem(
          value: 'المجموعة الوظيفية', child: Text('المجموعة الوظيفية')),
      DropdownMenuItem(value: 'المسمى الوظيفي', child: Text('المسمى الوظيفي')),
      DropdownMenuItem(value: 'المؤهل', child: Text('المؤهل')),
      DropdownMenuItem(value: 'العنوان', child: Text('العنوان')),
      DropdownMenuItem(
          value: 'تاريخ اخر ترقية', child: Text('تاريخ اخر ترقية')),
    ];
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text('عمل احصائية'),
          content: SizedBox(
            height: 150,
            width: 300,
            child: Column(
              children: [
                DropdownButton(
                    isExpanded: true,
                    value: selectedItem,
                    items: items,
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value!;
                      });
                    }),
                SizedBox(height: 16),
                customTextField(
                    controller: statisticsController, label: 'القيمة'),
                SizedBox(height: 16),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (statisticsController.text != '') {
                  var employeesData = data.where((item) {
                    return item[arabicToEnglishDataNames[selectedItem]]
                        .toString()
                        .contains(statisticsController.text);
                  }).toList();
                  List<Map<String, dynamic>> filteredEmployees =
                      employeesData.map((employee) {
                    return {
                      'الإسم': employee['name'],
                      '$selectedItem':
                          employee[arabicToEnglishDataNames[selectedItem]]
                    };
                  }).toList();
                  context
                      .read<DatabaseCubit>()
                      .createStatistics(filteredEmployees);
                  Navigator.pop(context);
                } else {}
              },
              child: Text('عمل احصائية'),
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
    return Scaffold(
        backgroundColor: clr(4),
        appBar: customAppBar('قاعدة البيانات', context, true),
        body: BlocBuilder<DatabaseCubit, DatabaseState>(
          builder: (context, state) {
            if (state is DatabaseEmployeesLoaded) {
              return Container(
                margin: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
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
                              label: 'تعديل موظف', onPressed: () async {}),
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
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        // employee status generation
                        customButton(
                            label: 'بيان حالة وظيفية',
                            onPressed: () {
                              buildEmployeeStatusFile(state.data);
                            }),
                        SizedBox(width: 16),
                        // statistics generation
                        customButton(
                            label: 'إحصائية',
                            onPressed: () {
                              makeStatistics(state.data);
                            })
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: TableBorder.all(color: clr(3), width: 1),
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('الاسم')),
                          DataColumn(label: Text('الرقم القومي')),
                          DataColumn(label: Text('تاريخ التعيين')),
                          DataColumn(label: Text('الرقم التأميني')),
                          DataColumn(label: Text('تاريخ التعاقد')),
                          DataColumn(label: Text('المجموعة الوظيفية')),
                          DataColumn(label: Text('المسمى الوظيفي')),
                          DataColumn(label: Text('المؤهل')),
                          DataColumn(label: Text('العنوان')),
                          DataColumn(label: Text('تاريخ اخر ترقية')),
                        ],
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
                          return DataRow(
                            cells: [
                              DataCell(Text(item['employeeid'].toString())),
                              DataCell(Text(item['name'])),
                              DataCell(Text(item['nationalidnumber'])),
                              DataCell(Text(item['dateofappointment'])),
                              DataCell(Text(item['insurancenumber'])),
                              DataCell(Text(item['contractdate'])),
                              DataCell(Text(item['functionalgroup'])),
                              DataCell(Text(item['jobtitle'])),
                              DataCell(Text(item['degree'])),
                              DataCell(Text(item['address'])),
                              DataCell(Text(item['dateoflastpromotion'])),
                            ],
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
