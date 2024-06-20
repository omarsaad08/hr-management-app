import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/database_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';

class DatabaseHome extends StatefulWidget {
  const DatabaseHome({super.key});

  @override
  State<DatabaseHome> createState() => _DatabaseHomeState();
}

class _DatabaseHomeState extends State<DatabaseHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar('قاعدة البيانات', context, true),
        body: BlocBuilder<DatabaseCubit, DatabaseState>(
          builder: (context, state) {
            if (state is DatabaseEmployeesLoaded) {
              return ListView(
                children: [
                  Row(
                    children: [
                      customButton(
                          label: 'إضافة موظف',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/database_add_employee');
                          }),
                      customButton(label: 'بحث موظف', onPressed: () {}),
                      customButton(label: 'إزالة موظف', onPressed: () {})
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder.all(color: Colors.black, width: 1),
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
              );
            } else {
              context.read<DatabaseCubit>().getAllemployees();
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
