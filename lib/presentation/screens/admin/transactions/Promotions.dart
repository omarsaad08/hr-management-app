// presentation/screens/transactions/Promotions.dart
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/custom_sub_trans.dart';
import 'package:hr_management_app/presentation/components/transactionsAppBar.dart';

class Promotions extends StatefulWidget {
  const Promotions({super.key});

  @override
  State<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('الترقيات', context, true),
      body: custom_sub_trans(
          // sub_title1: 'نوع الترقية',
          sub_title2: 'الجهات المعلمة',
          type: 'promotions',
          trans_options: ['']),
    );
  }
}
