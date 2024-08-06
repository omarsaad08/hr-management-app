// presentation/screens/transactions/transactions.dart

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';
import 'package:hr_management_app/presentation/components/hoveringbutton.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:hr_management_app/presentation/components/transactionsAppBar.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr(3),
      appBar: customAppBar('المعاملات', context, true),
      body: customContainer(
          width: 800,
          height: 600,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HoverButton(context, name: 'الجزاءات', routeName: 'Penalties'),
                HoverButton(context, name: 'العلاوات', routeName: 'Bonuses'),
                HoverButton(context, name: 'الأجازات', routeName: 'Vacations'),
                HoverButton(context, name: 'الترقيات', routeName: 'Promotions'),
                HoverButton(context, name: 'الطلبات', routeName: 'requests'),
              ],
            ),
          )),
    );
  }
}
