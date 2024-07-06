import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/database_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class Statistics extends StatefulWidget {
  List data;
  Statistics({super.key, required this.data});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
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
  @override
  List<DropdownMenuItem<String>> items = [];
  String? selectedItem;
  void initState() {
    super.initState();
    selectedItem = 'الاسم';
    for (var option in arabicToEnglishDataNames.keys.toList()) {
      items.add(DropdownMenuItem(value: option, child: Text(option)));
    }
    statisticsIsCheckedList = List.generate(
        arabicToEnglishDataNames.keys.toList().length, (index) => false);
  }

  TextEditingController statisticsController = TextEditingController();
  List<bool> statisticsIsCheckedList = [];
  Widget checkBoxes(List options) {
    List<Container> checkboxes = [];

    for (int i = 0; i < options.length; i++) {
      checkboxes.add(Container(
          width: 200,
          child: CheckboxListTile(
            value: statisticsIsCheckedList[i],
            onChanged: (newbool) {
              setState(() {
                statisticsIsCheckedList[i] = newbool!;
              });
            },
            activeColor: clr(2),
            checkColor: clr(4),
            title: Text(options[i]),
            controlAffinity: ListTileControlAffinity.leading,
          )));
    }
    return Wrap(
      children: checkboxes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseCubit, DatabaseState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: clr(3),
            appBar: customAppBar('قاعدة البيانات', context, true),
            body: customContainer(
                width: 1024,
                height: 720,
                child: ListView(
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
                    checkBoxes(arabicToEnglishDataNames.keys.toList()),
                    customButton(
                      onPressed: () {
                        if (statisticsController.text != '') {
                          var employeesData = widget.data.where((item) {
                            return item[arabicToEnglishDataNames[selectedItem]]
                                .toString()
                                .contains(statisticsController.text);
                          }).toList();
                          List<Map<String, dynamic>> filteredEmployees =
                              employeesData.map((employee) {
                            Map<String, dynamic> employeeData = {};
                            List dataNames =
                                arabicToEnglishDataNames.keys.toList();
                            for (int i = 0; i < dataNames.length; i++) {
                              if (statisticsIsCheckedList[i]) {
                                employeeData[dataNames[i]] = employee[
                                    arabicToEnglishDataNames[dataNames[i]]];
                              }
                            }
                            return employeeData;
                          }).toList();
                          context
                              .read<DatabaseCubit>()
                              .createStatistics(filteredEmployees);
                        } else {}
                      },
                      label: 'عمل احصائية',
                    ),
                  ],
                )));
      },
    );
  }
}
