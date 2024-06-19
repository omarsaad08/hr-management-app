import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class ArchiveDocument extends StatefulWidget {
  final List data;
  ArchiveDocument({super.key, required this.data});

  @override
  State<ArchiveDocument> createState() => _ArchiveDocumentState();
}

class _ArchiveDocumentState extends State<ArchiveDocument> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar('user document'),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
          decoration: BoxDecoration(color: clr(3)),
          child: Container(
            decoration: BoxDecoration(
              color: clr(4),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.all(32),
            child: ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    index == 0
                        ? customButton(
                            label: 'إضافة',
                            onPressed: () => Navigator.pushNamed(
                                context, '/add_to_user_archive'))
                        : Container(),
                    Text(widget.data[index]['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
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
        ));
  }
}
