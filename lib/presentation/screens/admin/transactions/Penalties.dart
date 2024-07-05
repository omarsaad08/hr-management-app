// presentation/screens/transactions/Penalties.dart
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/custom_sub_trans.dart';
import 'package:hr_management_app/presentation/components/transactionsAppBar.dart';

class Penalties extends StatefulWidget {
  const Penalties({Key? key}) : super(key: key);

  @override
  _PenaltiesState createState() => _PenaltiesState();
}

class _PenaltiesState extends State<Penalties> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('الجزاءات', context, true),
      body: custom_sub_trans(
        sub_title2: 'الجهات المعلمة',
        type: 'penalties',
        trans_options: [],
      ),
    );
  }
}
