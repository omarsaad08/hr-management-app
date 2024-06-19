import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/data/web_services/archive_web_services.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/addUserArchive.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/addToUserArchive.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/archiveDocument.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/search.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/userArchive.dart';

class AppRouter {
  late ArchiveWebServices archiveWebServices;
  late UserArchiveCubit userArchiveCubit;
  AppRouter() {
    archiveWebServices = ArchiveWebServices();
    userArchiveCubit = UserArchiveCubit(archiveWebServices: archiveWebServices);
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
      default:
    }
  }
}
