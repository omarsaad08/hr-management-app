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
    'ID': 'employeeid',
    'الاسم': 'name',
    'الرقم القومي': 'nationalidnumber',
    'تاريخ استلام العمل': 'dateofappointment',
    'العنوان': 'address',
    'الرقم التأميني': 'insurancenumber',
    'تاريخ التعيين / التعاقد': 'contractdate',
    'المجموعة الوظيفية': 'functionalgroup',
    'المسمى الوظيفي': 'jobtitle',
    'الدرجة الوظيفية': 'degree',
    'تاريخ اخر ترقية': 'dateoflastpromotion',
    'النوع': 'gender',
    'الديانة': 'religion',
    'تاريخ الميلاد': 'date_of_birth',
    'رقم الهاتف': 'phone_number',
    'الحالة من التجنيد': 'military_service_status',
    'المجموعة النوعية': 'jobcategory',
    'الادارة': 'administration',
    'الوظيفة الحالية': 'currentjob',
    'المؤهل': 'qualification',
    'نوع العقد': 'typeofcontract',
    'اخر تقرير': 'report',
    'الحالة من العمل': 'employmentstatus'
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
  String selectedItem = 'تاريخ التعيين';
  void makeStatistics(List data) {
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
    List<DataColumn> columns = [];
    arabicToEnglishDataNames.keys.forEach(
      (element) {
        columns.add(DataColumn(label: Text(element)));
      },
    );
    List<DataCell> createRow(Map item) {
      List<DataCell> row = [];
      arabicToEnglishDataNames.values.forEach((element) {
        row.add(DataCell(Text(item[element].toString())));
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
                margin: EdgeInsets.all(16),
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

                          SizedBox(width: 16),

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
                                // Navigator.pushNamed(
                                //     context, '/database_statistics');
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
