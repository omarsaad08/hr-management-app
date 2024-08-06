// import 'package:cura/UploadImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

Widget MyDrawer(BuildContext context) {
  final storage = FlutterSecureStorage();
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              //color: Colors.grey[200],
              ),
          accountName: Text("الاسم ", style: TextStyle(color: Colors.black)),
          accountEmail: Text(""),
          currentAccountPicture: Container(
            alignment: Alignment.center,
            child: Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('asset/user.png'),
                // child: Icon(
                //   Icons.person,
                //   size: 50,
                //   color: Colors.white,
                // ),
              ),
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: Icon(
              Icons.settings,
              color: clr(2),
            ),
            title: Text(
              'الإعدادات',
              style: TextStyle(
                color: clr(3),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: clr(2),
            ),
            title: Text(
              'تسجيل خروج',
              style: TextStyle(
                color: clr(3),
              ),
            ),
            onTap: () {
              storage.delete(key: 'jwt');
              Navigator.popAndPushNamed(context, '/login');
            },
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: Icon(
              Icons.help,
              color: clr(2),
            ),
            title: Text(
              'مساعدة',
              style: TextStyle(
                color: clr(3),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}
