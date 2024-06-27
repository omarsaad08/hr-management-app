import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class ArchiveDocument extends StatefulWidget {
  final List data;
  final String dataName;
  final String userId;
  final String dataCategory;
  ArchiveDocument(
      {super.key,
      required this.data,
      required this.dataName,
      required this.userId,
      required this.dataCategory});

  @override
  State<ArchiveDocument> createState() => _ArchiveDocumentState();
}

class _ArchiveDocumentState extends State<ArchiveDocument> {
  TextEditingController imageNameController = TextEditingController();
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

  void addImage() {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          title: Text('إضافة للأرشيف'),
          content: Container(
            height: 400,
            child: Column(
              children: [
                customTextField(
                    controller: imageNameController, label: 'إسم الصورة'),
                customButton(
                    label: 'اختيار الصورة',
                    onPressed: () async {
                      file = await pickFile();
                    })
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<UserArchiveCubit>().postImage(
                    userId: widget.userId,
                    filetype: widget.dataCategory,
                    filePath: file!.path,
                    filename: imageNameController.text);
                Navigator.pop(context);
              },
              child: Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userArchiveCubit = context.read<UserArchiveCubit>();
    return Scaffold(
        backgroundColor: clr(4),
        appBar: customAppBar(widget.dataName, context, true, onPop: () {}),
        body: BlocBuilder<UserArchiveCubit, UserArchiveState>(
          builder: (context, state) {
            if (state is UserArchiveImagesLoaded ||
                state is UserArchiveImageAdded) {
              if (state is UserArchiveImageAdded) {}
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // IconButton(
                    //     onPressed: () {
                    //       userArchiveCubit.getImages(
                    //           doc: widget.dataCategory, id: widget.userId);
                    //     },
                    //     icon: Icon(Icons.refresh)),
                    // customButton(
                    //     label: 'إضافة',
                    //     onPressed: () => Navigator.pushNamed(
                    //         context, '/add_to_user_archive',
                    //         arguments: [widget.dataCategory, widget.userId])),
                    customButton(
                        label: 'إضافة',
                        onPressed: () {
                          addImage();
                        }),
                    SizedBox(
                      height: 8,
                    ),
                    state is UserArchiveImageAdded
                        ? Text('تمت إضافة الصورة')
                        : Container(),
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Text(widget.data[index]['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              SizedBox(
                                height: 16,
                              ),
                              Image.memory(
                                widget.data[index]['binary'],
                                width: 1000,
                              ),
                              SizedBox(
                                height: 64,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is UserArchiveImagesLoading ||
                state is UserArchiveLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Text('state: ${state.toString()}');
            }
          },
        ));
  }
}
