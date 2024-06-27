import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/app_router.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/data/web_services/archive_web_services.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  // this was for testing user authentication and will be used later
  // final storage = FlutterSecureStorage();
  // String? token = await storage.read(key: 'jwt');
  // print('token: $token');
  // var loggedIn = false;
  // token = null;
  // if (token.runtimeType == String) {
  // } else {
  //   loggedIn = false;
  // }

  runApp(HRManagementApp(appRouter: AppRouter()));
}

class HRManagementApp extends StatelessWidget {
  final AppRouter appRouter;
  const HRManagementApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserArchiveCubit>(
          create: (context) =>
              UserArchiveCubit(archiveWebServices: ArchiveWebServices()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // fontFamily: "Hacen-Liner-Print-out",
            fontFamily: "Cairo",
            colorScheme: ColorScheme.light(
              primary: clr(1),
              onPrimary: clr(5),
              onSurface: clr(1),
            )),
        initialRoute: '/admin_home',
        onGenerateRoute: appRouter.generateRoute,
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
}
