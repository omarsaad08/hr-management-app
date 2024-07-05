// presentation/screens/transactions/bonuses.dart
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/custom_sub_trans.dart';
import 'package:hr_management_app/presentation/components/transactionsAppBar.dart';

class Vacations extends StatefulWidget {
  const Vacations({Key? key}) : super(key: key);

  @override
  _VacationsState createState() => _VacationsState();
}

class _VacationsState extends State<Vacations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('الاجازات', context, true),
      body: custom_sub_trans(
        sub_title1: 'نوع الاجازة',
        sub_title2: 'الجهات المعلمة',
        type: 'vacations',
        trans_options: [
          'اعتيادي',
          'مرضي',
          'عارضة',
          'رعاية الطفل',
          'إجازة خاصة',
          'إستثنائية'
        ],
      ),
    );
  }
}
