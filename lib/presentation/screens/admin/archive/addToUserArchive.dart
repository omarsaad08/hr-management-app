import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:hr_management_app/presentation/screens/admin/archive/userArchive.dart';

class AddToUserArchive extends StatefulWidget {
  final String doc;
  final String id;
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
  AddToUserArchive({super.key, required this.doc, required this.id});

  @override
  State<AddToUserArchive> createState() => _AddToUserArchiveState();
}

class _AddToUserArchiveState extends State<AddToUserArchive> {
  TextEditingController userIdController = TextEditingController();

  TextEditingController fileNameController1 = TextEditingController();

  TextEditingController fileCategoryController1 = TextEditingController();

  File? file;

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      PlatformFile platformFile = result.files.first;
      File file = File(platformFile.path!);
      return file;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final userArchiveCubit = context.read<UserArchiveCubit>();
    userIdController.text = widget.id;
    fileCategoryController1.text = widget.doc;
    return Scaffold(
        appBar: customAppBar('إضافة للأرشيف', context, true),
        body: BlocListener<UserArchiveCubit, UserArchiveState>(
          listener: (context, state) {
            if (state is UserArchiveImageAdded) {
              Navigator.popUntil(
                  context, ModalRoute.withName('/archive_search'));
              userArchiveCubit.getDoc(id: widget.id);
            }
          },
          child: BlocBuilder<UserArchiveCubit, UserArchiveState>(
            builder: (context, state) {
              return Column(
                children: [
                  customTextField(
                      controller: userIdController, label: 'كود الموظف'),
                  customTextField(
                      controller: fileNameController1, label: 'اسم الصورة'),
                  customTextField(
                      controller: fileCategoryController1, label: 'النوع'),
                  customButton(
                      label: 'صورة 1',
                      onPressed: () async {
                        file = await pickFile();
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  customButton(
                      label: 'اضافة للأرشيف',
                      onPressed: () async {
                        // String filename = file!.path.split('/').last;
                        context.read<UserArchiveCubit>().postImage(
                            userId: userIdController.text,
                            filetype: fileCategoryController1.text,
                            filePath: file!.path,
                            filename: fileNameController1.text);
                      })
                ],
              );
            },
          ),
        ));
  }
}
