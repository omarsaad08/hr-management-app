import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/app_router.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:dio/dio.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/userArchive.dart';

Dio dio = Dio();

class ArchiveSearch extends StatefulWidget {
  const ArchiveSearch({super.key});

  @override
  State<ArchiveSearch> createState() => _ArchiveSearchState();
}

class _ArchiveSearchState extends State<ArchiveSearch> {
  final _formKey = GlobalKey<FormState>();
  AppRouter appRouter = AppRouter();
  TextEditingController idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr(3),
      appBar: customAppBar('الأرشيف'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocListener<UserArchiveCubit, UserArchiveState>(
              listener: (context, state) {
                if (state is UserArchiveLoaded) {
                  Navigator.pushNamed(context, '/user_archive',
                      arguments: state.data);
                } else if (state is UserArchiveError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: BlocBuilder<UserArchiveCubit, UserArchiveState>(
                builder: (context, state) {
                  if (state is UserArchiveInitial) {
                    return Center(
                      child: Container(
                        width: 600,
                        height: 400,
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                            color: clr(4),
                            borderRadius: BorderRadius.circular(32)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "أدخل كود الموظف",
                              style: TextStyle(fontSize: 36),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            customTextField(
                                controller: idController, label: 'كود الموظف'),
                            SizedBox(
                              height: 20,
                            ),
                            customButton(
                                label: 'متابعة',
                                onPressed: () {
                                  context
                                      .read<UserArchiveCubit>()
                                      .getDoc(id: idController.text);
                                }),
                            SizedBox(height: 20),
                            customButton(
                                label: 'إضافة موظف للأرشيف',
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/add_user_archive');
                                })
                          ],
                        ),
                      ),
                    );
                  } else if (state is UserArchiveLoading) {
                    return CircularProgressIndicator();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*

*/