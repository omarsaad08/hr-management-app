import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/custom_sub_trans.dart';
import 'package:hr_management_app/presentation/components/transactionsAppBar.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('الإحصائيات', context, true),
      body: custom_sub_trans(
        sub_title1: 'الفئات',
        sub_title2: null,
        type: 'statistics',
        trans_options: arabicToEnglishDataNames.keys.toList(),
      ),
    );
  }
}
