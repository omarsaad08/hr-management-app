import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class UserArchive extends StatefulWidget {
  final String userName;
  final Map<String, String> categories = {
    'penalties': 'الجزاءات',
    'vacations': 'الأجازات',
    'ID': 'صورة البطاقة ',
    'innerTransfers': 'النقل',
    'secondments': 'الإعارات والندب',
    'employmentContract': 'عقد العمل',
    'academicQualification': 'المؤهل الدراسي',
    'certificates': 'الشهادات',
    'privateVacations': 'الإجازات الخاصة',
    'personalPhoto': 'الصورة الشخصية',
    'bankingTransactions': 'المعاملات البنكية',
    'disability': 'ذوي الهمم',
  };
  UserArchive({super.key, required this.userName});

  @override
  State<UserArchive> createState() => _UserArchiveState();
}

class _UserArchiveState extends State<UserArchive> {
  late String dataName;
  late String dataCategory;
  // @override
  // void initState() {
  //   super.initState();
  //   userName = BlocProvider.of<UserArchiveCubit>(context).getDoc();
  // }

  @override
  Widget build(BuildContext context) {
    final userArchiveCubit = context.read<UserArchiveCubit>();
    return Scaffold(
        appBar: customAppBar(widget.userName, context, true),
        body: BlocListener<UserArchiveCubit, UserArchiveState>(
          listener: (context, state) {
            if (state is UserArchiveImagesLoaded) {
              Navigator.pushNamed(context, '/archive_document', arguments: [
                state.data,
                dataName,
                widget.userName,
                dataCategory
              ]);
            }
          },
          child: BlocBuilder<UserArchiveCubit, UserArchiveState>(
            builder: (context, state) {
              if (state is UserArchiveLoaded ||
                  state is UserArchiveImagesLoaded ||
                  state is UserArchiveImageAdded) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
                  decoration: BoxDecoration(color: clr(3)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: clr(4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.all(32),
                    child: ListView.builder(
                      itemCount: widget.categories.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            index == 0
                                ? IconButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      print(state);
                                    },
                                    icon: Icon(Icons.close))
                                : Container(),
                            Container(
                              margin: EdgeInsets.only(top: 12, right: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right:
                                          BorderSide(color: clr(1), width: 3))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.categories.values.toList()[index],
                                      style: TextStyle(fontSize: 24)),
                                  customButton(
                                      label: 'عرض',
                                      onPressed: () {
                                        dataName = widget.categories.values
                                            .toList()[index];
                                        dataCategory = widget.categories.keys
                                            .toList()[index];
                                        // print('id: ${widget.userName}');
                                        // print(
                                        //     'doc: ${widget.categories.keys.toList()[index]}');
                                        context
                                            .read<UserArchiveCubit>()
                                            .getImages(
                                                doc: widget.categories.keys
                                                    .toList()[index],
                                                id: widget.userName);
                                      })
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              } else if (state is UserArchiveImagesLoading ||
                  state is UserArchiveLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UserArchiveError) {
                return customContainer(
                    width: 400,
                    height: 200,
                    child: Center(
                      child: Text('هذا الكود غير موجود'),
                    ));
              } else {
                return Text(
                    'something is going on, state: ${state.toString()}');
              }
            },
          ),
        ));
  }
}
