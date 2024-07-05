// components/transactionsAppBar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar customtransAppBar(String transtitle) {
  return AppBar(
    backgroundColor: Color(0xff232d5c),
    leading: IconButton(
      icon: Image.asset('images/filter.png'),
      onPressed: () {},
    ),
    title: Text(
      transtitle,
      style: TextStyle(
        color: Color(0xffE9EBF8),
        fontSize: 30.0,
      ),
    ),
    actions: [
      SizedBox(
        width: 80.0,
        child: IconButton(
          onPressed: () {}, // edit it later
          icon: Image.asset('images/user.png'),
        ),
      ),
    ],
    centerTitle: true,
  );
}
