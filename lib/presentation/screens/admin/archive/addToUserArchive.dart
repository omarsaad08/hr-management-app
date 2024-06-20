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

class AddToUserArchive extends StatelessWidget {
  TextEditingController userIdController = TextEditingController();
  TextEditingController fileNameController1 = TextEditingController();
  TextEditingController fileCategoryController1 = TextEditingController();
  File? file;
  AddToUserArchive({super.key});
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
    return Scaffold(
        appBar: customAppBar('إضافة للأرشيف', context, true),
        body: BlocBuilder<UserArchiveCubit, UserArchiveState>(
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
        ));
  }
}
