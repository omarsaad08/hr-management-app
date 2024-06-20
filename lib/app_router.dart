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
      case '/admin_home':
        return MaterialPageRoute(
          builder: (context) => AdminHome(),
        );
      case '/archive_search':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<UserArchiveCubit>(
            create: (context) => userArchiveCubit,
            child: ArchiveSearch(),
          ),
        );
      case '/user_archive':
        final data = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<UserArchiveCubit>(
            create: (context) => userArchiveCubit,
            child: UserArchive(userName: data),
          ),
        );
      case '/archive_document':
        final data = settings.arguments as List;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<UserArchiveCubit>(
            create: (context) => userArchiveCubit,
            child: ArchiveDocument(data: data),
          ),
        );
      case '/add_to_user_archive':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<UserArchiveCubit>(
                  create: (context) => userArchiveCubit,
                  child: AddToUserArchive(),
                ));
      case '/add_user_archive':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<UserArchiveCubit>(
                create: (context) => userArchiveCubit,
                child: AddUserArchive()));
      case '/database_home':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<DatabaseCubit>(
                  create: (context) {
                    databaseCubit =
                        DatabaseCubit(databaseWebServices: databaseWebServices);
                    return DatabaseCubit(
                        databaseWebServices: databaseWebServices);
                  },
                  child: DatabaseHome(),
                ));
      case '/database_add_employee':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<DatabaseCubit>(
                create: (context) => databaseCubit, child: AddEmployee()));
      default:
    }
  }
}
