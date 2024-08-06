import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/database_cubit.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/data/web_services/archive_web_services.dart';
import 'package:hr_management_app/data/web_services/database_web_services.dart';
import 'package:hr_management_app/presentation/screens/admin/admin_home.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/addUserArchive.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/addToUserArchive.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/archiveDocument.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/search.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/userArchive.dart';
import 'package:hr_management_app/presentation/screens/admin/database/addEmployee.dart';
import 'package:hr_management_app/presentation/screens/admin/database/database_home.dart';
import 'package:hr_management_app/presentation/screens/admin/database/employeeDetails.dart';
import 'package:hr_management_app/presentation/screens/admin/database/statistics.dart';
import 'package:hr_management_app/presentation/screens/admin/database/updateEmployee.dart';
import 'package:hr_management_app/presentation/screens/admin/transactions/Penalties.dart';
import 'package:hr_management_app/presentation/screens/admin/transactions/Promotions.dart';
import 'package:hr_management_app/presentation/screens/admin/transactions/bonuses.dart';
import 'package:hr_management_app/presentation/screens/admin/transactions/requests.dart';
import 'package:hr_management_app/presentation/screens/admin/transactions/transactions.dart';
import 'package:hr_management_app/presentation/screens/admin/transactions/vacations.dart';
import 'package:hr_management_app/presentation/screens/auth/login.dart';
import 'package:hr_management_app/presentation/screens/auth/signup.dart';
import 'package:hr_management_app/presentation/screens/no_internet.dart';
import 'package:hr_management_app/presentation/screens/user/head_home.dart';
import 'package:hr_management_app/presentation/screens/user/head_requests.dart';
import 'package:hr_management_app/presentation/screens/user/make_request.dart';
import 'package:hr_management_app/presentation/screens/user/prev_requests.dart';
import 'package:hr_management_app/presentation/screens/user/user_home.dart';
import 'package:hr_management_app/presentation/screens/user/user_info.dart';
import 'package:pdf/widgets.dart';

class AppRouter {
  late ArchiveWebServices archiveWebServices;
  late UserArchiveCubit userArchiveCubit;

  late DatabaseWebServices databaseWebServices;
  late DatabaseCubit databaseCubit;
  AppRouter() {
    archiveWebServices = ArchiveWebServices();
    userArchiveCubit = UserArchiveCubit(archiveWebServices: archiveWebServices);
    databaseWebServices = DatabaseWebServices();
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/no_internet':
        return MaterialPageRoute(builder: (context) => NoInternetScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => Login());
      case '/signup':
        return MaterialPageRoute(
          builder: (context) => Signup(),
        );
      case '/user_home':
        return MaterialPageRoute(builder: (context) => UserHome());
      case '/user_info':
        return MaterialPageRoute(builder: (context) => UserInfo());
      case '/make_request':
        return MaterialPageRoute(builder: (context) => MakeRequest());
      case '/prev_requests':
        return MaterialPageRoute(builder: (context) => PrevRequests());
      case '/head_home':
        return MaterialPageRoute(builder: (context) => HeadHome());
      case '/head_requests':
        return MaterialPageRoute(builder: (context) => HeadRequests());
      case '/admin_home':
        return MaterialPageRoute(
          builder: (context) => AdminHome(),
        );
      case '/archive_search':
        return MaterialPageRoute(builder: (context) => ArchiveSearch());
      case '/user_archive':
        final data = settings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => UserArchive(userName: data));
      case '/archive_document':
        final routeData = settings.arguments as List;
        return MaterialPageRoute(
            builder: (context) => ArchiveDocument(
                  data: routeData[0],
                  dataName: routeData[1],
                  userId: routeData[2],
                  dataCategory: routeData[3],
                ));
      case '/add_to_user_archive':
        final data = settings.arguments as List;
        return MaterialPageRoute(
            builder: (context) => AddToUserArchive(doc: data[0], id: data[1]));
      case '/add_user_archive':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<UserArchiveCubit>(
                create: (context) => userArchiveCubit,
                child: AddUserArchive()));
      case '/database_home':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<DatabaseCubit>(
                  create: (context) =>
                      DatabaseCubit(databaseWebServices: databaseWebServices),
                  child: DatabaseHome(),
                ));
      case '/employee_details':
        final id = settings.arguments as int;
        return MaterialPageRoute(builder: (context) => EmployeeDetails(id: id));
      case '/database_add_employee':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<DatabaseCubit>(
                create: (context) =>
                    DatabaseCubit(databaseWebServices: databaseWebServices),
                child: AddEmployee()));
      case '/database_update_employee':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<DatabaseCubit>(
                create: (context) =>
                    DatabaseCubit(databaseWebServices: databaseWebServices),
                child: UpdateEmployee()));
      case '/database_statistics':
        final data = settings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<DatabaseCubit>(
                create: (context) =>
                    DatabaseCubit(databaseWebServices: databaseWebServices),
                child: Statistics(data: data)));
      case 'transactions':
        return MaterialPageRoute(builder: (context) => Transactions());
      case 'Penalties':
        return MaterialPageRoute(builder: (context) => Penalties());
      case 'Bonuses':
        return MaterialPageRoute(builder: (context) => Bonuses());
      case 'Vacations':
        return MaterialPageRoute(builder: (context) => Vacations());
      case 'Promotions':
        return MaterialPageRoute(builder: (context) => Promotions());
      case 'requests':
        return MaterialPageRoute(builder: (context) => Requests());
      default:
    }
  }
}
