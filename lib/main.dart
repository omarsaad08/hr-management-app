import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/app_router.dart';
import 'package:hr_management_app/business_logic/cubit/transactions_cubit.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/business_logic/cubit/user_request_cubit.dart';
import 'package:hr_management_app/data/sockets/socket_service.dart';
import 'package:hr_management_app/data/sockets/storage_service.dart';
import 'package:hr_management_app/data/web_services/archive_web_services.dart';
import 'package:hr_management_app/data/web_services/auth_web_services.dart';
import 'package:hr_management_app/data/web_services/database_web_services.dart';
import 'package:hr_management_app/data/web_services/requests_web_services.dart';
import 'package:hr_management_app/data/web_services/sockets_web_services.dart';
import 'package:hr_management_app/data/web_services/transactions_web_services.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool loggedIn = false;
bool admin = false;
bool head = false;
var data;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthWebServices auth = AuthWebServices();
  SocketsWebServices socketsWebServices = SocketsWebServices();
  DatabaseWebServices databaseWebServices = DatabaseWebServices();
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'jwt');
  print('token: $token');
  if (token != null) {
    data = await auth.whoami(token);
    if (data != null) {
      print(data);
      loggedIn = true;
      SocketService.initialize();
      final Map employeeData =
          await databaseWebServices.getEmployee(id: data['userId']);
      if (employeeData["employee"]["role"] == "الموارد البشرية") {
        admin = true;
      } else if (["مدير", "الحي", "رئيس"]
          .contains(employeeData["employee"]["role"])) {
        head = true;
        print('he is head');
      }
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("userId", data["userId"]);
      sharedPreferences.setString("role", employeeData['employee']['role']);
      print(employeeData);
      // Connect to socket on app start
      socketsWebServices.connectToSocket(
          data['userId'], employeeData['employee']['role']);
    }
  }

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
        BlocProvider<TransactionsCubit>(
            create: (context) => TransactionsCubit(
                transactionsWebServices: TransactionsWebServices())),
        BlocProvider<UserRequestCubit>(
            create: (context) =>
                UserRequestCubit(requestsWebServices: RequestsWebServices()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // fontFamily: "Hacen-Liner-Print-out",
            fontFamily: "Cairo",
            // fontFamily: "NotoNaskhArabic",
            colorScheme: ColorScheme.light(
              primary: clr(1),
              onPrimary: clr(5),
              onSurface: clr(1),
            )),
        initialRoute: !loggedIn
            ? '/login'
            : admin && Platform.isWindows
                ? '/admin_home'
                : head || admin
                    ? '/head_home'
                    : '/user_home',

        // initialRoute: '/admin_home',
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
