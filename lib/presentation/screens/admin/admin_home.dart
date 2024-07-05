import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: clr(3),
        appBar: customAppBar('الصفحة الرئيسية', context, false),
        body: customContainer(
            width: 875,
            height: 600,
            child: ListView(
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 16,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'transactions');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 140, horizontal: 96),
                              decoration: BoxDecoration(
                                  color: clr(1),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'images/transfer.png',
                                    width: 160,
                                  ),
                                  SizedBox(height: 16),
                                  Text('المعاملات',
                                      style: TextStyle(
                                          color: clr(5),
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 325,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/database_home');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 32, horizontal: 64),
                                  decoration: BoxDecoration(
                                      color: clr(2),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'images/database.png',
                                        width: 120,
                                      ),
                                      // SizedBox(height: 16),
                                      Text('قاعدة البيانات',
                                          style: TextStyle(
                                              color: clr(0),
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/archive_search');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 32, horizontal: 96),
                                  decoration: BoxDecoration(
                                      color: clr(3),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'images/archive.png',
                                        width: 120,
                                      ),
                                      SizedBox(height: 16),
                                      Text('الأرشيف',
                                          style: TextStyle(
                                              color: clr(0),
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}
