import 'dart:io';
// import 'package:hr_management_app/MyDrawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class Uploadimage extends StatefulWidget {
  @override
  State<Uploadimage> createState() => _UploadimageState();
}

class _UploadimageState extends State<Uploadimage> {
  // Uint8List? _image;
  // File? selectedImage;
  // Future<void> _pickImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       selectedImage = File(pickedFile.path);
  //       _image = selectedImage!.readAsBytesSync();
  //     });
  //   }
  // }

  File? file;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      PlatformFile platformFile = result.files.first;
      setState(() {
        file = File(platformFile.path!);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr(3),
      appBar: customAppBar("نظام إدارة الموارد البشرية ", context, false),
      // drawer: MyDrawer(context),
      body: Center(
        child: Container(
          height: 400.0,
          width: 550,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.0),
            color: clr(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 4,
                blurRadius: 4,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Center(
            child: Stack(children: [
              Container(
                // radius: 100,
                child: file != null
                    ? Image.file(file!)
                    : Image.asset('images/user.png'),
                // backgroundImage: ,
              ),
              IconButton(
                onPressed: () async {
                  await pickFile();
                },
                icon: Icon(Icons.add_a_photo_outlined),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
