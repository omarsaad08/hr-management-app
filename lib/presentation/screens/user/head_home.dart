import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hr_management_app/presentation/components/MyDrawer.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeadHome extends StatefulWidget {
  const HeadHome({super.key});

  @override
  State<HeadHome> createState() => _HeadHomeState();
}

class _HeadHomeState extends State<HeadHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: clr(4),
        appBar: customAppBar('نظام ادارة الموارد البشرية', context, false),
        drawer: MyDrawer(context),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            List<ConnectivityResult> connectivity,
            Widget child,
          ) {
            final bool connected =
                !connectivity.contains(ConnectivityResult.none);
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  height: !connected ? 24.0 : 0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                    child: Center(
                      child: Text("${connected ? 'ONLINE' : 'لا يوجد انترنت'}"),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 32),
                        Expanded(
                          child: customButton(
                              label: 'الطلبات',
                              onPressed: () {
                                Navigator.pushNamed(context, '/make_request');
                              }),
                        ),
                        SizedBox(height: 32),
                        Expanded(
                            child: customButton(
                                label: 'الطلبات السابقة',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/prev_requests');
                                })),
                        SizedBox(height: 32),
                        Expanded(
                          child: customButton(
                              label: 'طلبات الموظفين',
                              onPressed: () {
                                Navigator.pushNamed(context, '/head_requests');
                              }),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  customButton(
                      label: 'بياناتي',
                      onPressed: () {
                        Navigator.pushNamed(context, '/user_info');
                      }),
                  SizedBox(height: 8),
                  customButton(
                      label: 'الطلبات',
                      onPressed: () {
                        Navigator.pushNamed(context, '/make_request');
                      }),
                  SizedBox(height: 8),
                  customButton(
                      label: 'الطلبات السابقة',
                      onPressed: () {
                        Navigator.pushNamed(context, '/prev_requests');
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
