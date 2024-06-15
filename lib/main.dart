import 'package:flutter/material.dart';
import 'package:hr_management_app/components/theme.dart';
import 'package:hr_management_app/screens/admin/archive/userArchive.dart';
import 'package:hr_management_app/screens/home.dart';

import 'package:hr_management_app/screens/auth/login.dart';
import 'package:hr_management_app/screens/auth/signup.dart';

import 'package:hr_management_app/screens/admin/archive/search.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt');
  print('token: $token');
  var loggedIn = false;
  token = null;
  if (token.runtimeType == String) {
  } else {
    loggedIn = false;
  }
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Hacen-Liner-Print-out",
      ),
      // home: loggedIn ? Home() : Signup(),
      home: ArchiveSearch(),
      routes: {
        '/home': (context) => Home(),
        '/signup': (context) => Signup(),
        '/login': (context) => Login(),
        '/arhive_search': (context) => ArchiveSearch(),
        '/user_archive': (context) => UserArchive()
      },
      // for making the app RTL
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar", "AE"),
      ],
      locale: Locale("ar", "AE"),
    ),
  );
}
