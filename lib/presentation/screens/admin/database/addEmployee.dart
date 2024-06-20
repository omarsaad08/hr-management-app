import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/database_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController insuranceNumberController = TextEditingController();
  TextEditingController functionalGroupController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  DateTime? dateOfAppointmentController;
  DateTime? contractDateController;
  DateTime? dateOfLastPromotionController;
  bool employeeAdded = false;
  Future<void> selectDate(BuildContext context, int num) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2100),
    );
    switch (num) {
      case 1:
        dateOfAppointmentController = pickedDate;
        break;
      case 2:
        contractDateController = pickedDate;
        break;
      case 3:
        dateOfLastPromotionController = pickedDate;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: clr(3),
        appBar: customAppBar('إضافة موظف', context, false),
        body: BlocBuilder<DatabaseCubit, DatabaseState>(
          builder: (context, state) {
            if (state is DatabaseAddingEmployee) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return customContainer(
                  width: double.infinity,
                  height: double.infinity,
                  child: ListView(children: [
                    customButton(
                        label: 'back',
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    customTextField(
                        controller: nameController, label: 'اسم الموظف'),
                    customTextField(
                        controller: nationalIdController,
                        label: 'الرقم القومي'),
                    customTextField(
                        controller: insuranceNumberController,
                        label: 'الرقم التأميني'),
                    customTextField(
                        controller: functionalGroupController,
                        label: 'المجموعة الوظيفية'),
                    customTextField(
                        controller: jobTitleController,
                        label: 'المسمى الوظيفي'),
                    customTextField(
                        controller: degreeController, label: 'المؤهل'),
                    customTextField(
                        controller: addressController, label: 'العنوان'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customButton(
                            label: 'اختيار تاريخ التعيين',
                            onPressed: () async {
                              await selectDate(context, 1);
                            }),
                        customButton(
                            label: 'اختيار تاريخ التعاقد',
                            onPressed: () async {
                              await selectDate(context, 2);
                            }),
                        customButton(
                            label: 'اختيار تاريخ اخر ترقية',
                            onPressed: () async {
                              await selectDate(context, 3);
                            }),
                        customButton(
                            label: 'إضافة',
                            onPressed: () {
                              Map<String, dynamic> employeeData = {
                                "name": nameController.text,
                                "nationalIDNumber": nationalIdController.text,
                                "dateOfAppointment":
                                    dateOfAppointmentController.toString(),
                                "insuranceNumber":
                                    insuranceNumberController.text,
                                "contractDate":
                                    contractDateController.toString(),
                                "functionalGroup":
                                    functionalGroupController.text,
                                "jobTitle": jobTitleController.text,
                                "degree": degreeController.text,
                                "address": addressController.text,
                                "dateOfLastPromotion":
                                    dateOfLastPromotionController.toString()
                              };
                              context
                                  .read<DatabaseCubit>()
                                  .addEmployee(employeeData: employeeData);

                              nameController.text = '';
                              nationalIdController.text = '';
                              insuranceNumberController.text = '';
                              functionalGroupController.text = '';
                              jobTitleController.text = '';
                              degreeController.text = '';
                              addressController.text = '';
                              dateOfAppointmentController = null;
                              contractDateController = null;
                              dateOfLastPromotionController = null;
                            }),
                      ],
                    ),
                    Text(state.toString()),
                  ]));
            }
          },
        ));
  }
}
