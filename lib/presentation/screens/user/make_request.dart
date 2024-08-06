import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/user_request_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:hr_management_app/presentation/components/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakeRequest extends StatefulWidget {
  const MakeRequest({super.key});

  @override
  State<MakeRequest> createState() => _MakeRequestState();
}

class _MakeRequestState extends State<MakeRequest> {
  DateTimeRange? selectedRange;
  String? selectedValue;
  TextEditingController contentController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  dateTimeRangePicker() async {
    selectedRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 25),
        lastDate: DateTime(DateTime.now().year + 1),
        initialDateRange: DateTimeRange(
          end: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 13),
          start: DateTime.now(),
        ),
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600.0, maxHeight: 600),
                child: child,
              )
            ],
          );
        });
    print(selectedRange!.duration.inDays);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserRequestCubit>();
    cubit.emitInitial();

    return Scaffold(
      appBar: customAppBar('عمل طلب', context, true),
      body: BlocBuilder<UserRequestCubit, UserRequestState>(
        builder: (context, state) {
          if (state is UserRequestError) {
            return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                color: clr(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close),
                    SizedBox(
                      height: 16,
                    ),
                    Text("عذرا يوجد خطأ")
                  ],
                ));
          } else {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  state is UserRequestMade
                      ? Icon(Icons.check)
                      : state is MakingUserRequest
                          ? CircularProgressIndicator()
                          : Container(),
                  SizedBox(height: 8),
                  Text('نوع الطلب',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'اختر النوع',
                    ),
                    value: selectedValue,
                    items: <String>[
                      'اجازة اعتيادي',
                      'اجازة عارضة',
                      'افادة',
                      'بيان حالة وظيفية',
                      "مفردات مرتب",
                      "أجور متغيرة",
                      "أخر"
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  selectedValue == "أخر"
                      ? customTextField(
                          controller: typeController,
                          label: "أكتب النوع",
                        )
                      : Container(),
                  SizedBox(height: 8),
                  ['اجازة اعتيادي', 'اجازة عارضة'].contains(selectedValue)
                      ? customButton(
                          label: 'اختيار التاريخ',
                          onPressed: () async {
                            await dateTimeRangePicker();
                          })
                      : customTextField(
                          controller: contentController,
                          label: "المحتوى",
                        ),
                  SizedBox(height: 8),
                  customButton(
                      label: 'طلب',
                      onPressed: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        final id = sharedPreferences.getString("userId");
                        final role = sharedPreferences.getString("role");
                        String receiver_role = "الموارد البشرية";
                        if (selectedValue == 'اجازة اعتيادي') {
                          print('employeeRole: ${role}');
                          if (role!.contains('موظف')) {
                            receiver_role = 'مدير${role.substring(4)}';
                          } else if (role.contains('مدير')) {
                            receiver_role = 'سكرتير عام الحي';
                          } else {
                            receiver_role = 'رئيس الحي';
                          }
                        }
                        final data = {
                          "employeeid": id,
                          "receiver_role": receiver_role,
                          // "receiver_name": "Mohammed",
                          "content": ['اجازة اعتيادي', 'اجازة عارضة']
                                  .contains(selectedValue)
                              ? 'من ${selectedRange!.start.toString().split(' ')[0]} الى ${selectedRange!.start.toString().split(' ')[0]}'
                              : contentController.text,
                          "dateofrequest":
                              DateTime.now().toString().split(' ')[0],
                          "requestType": selectedValue
                        };
                        print(data);
                        cubit.makeRequest(data);
                      })
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
