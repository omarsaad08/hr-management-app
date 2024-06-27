import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/user_archive_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class AddUserArchive extends StatelessWidget {
  const AddUserArchive({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController idController = TextEditingController();
    return Scaffold(
      backgroundColor: clr(3),
      appBar: customAppBar('إضافة موظف للأرشيف', context, true),
      body: BlocBuilder<UserArchiveCubit, UserArchiveState>(
        builder: (context, state) {
          if (state is UserArchiveAddUserError) {
            return Text('error ${state.message}');
          } else {
            print(state);
            return Center(
              child: Container(
                width: 600,
                height: 400,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                    color: clr(4), borderRadius: BorderRadius.circular(32)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state is UserArchiveUserAdded
                        ? Text('تم إضافة الموظف')
                        : state is UserArchiveAddingUser
                            ? CircularProgressIndicator()
                            : Container(),
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
                        label: 'أضف للأرشيف',
                        onPressed: () {
                          print('userid: ${idController.text}');
                          context
                              .read<UserArchiveCubit>()
                              .addUser(idController.text);
                        })
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
