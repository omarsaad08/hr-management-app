import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/database_cubit.dart';
import 'package:hr_management_app/presentation/components/customAppBar.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'package:hr_management_app/presentation/components/customContainer.dart';
import 'package:hr_management_app/presentation/components/customTextField.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:hr_management_app/presentation/components/theme.dart';

class UpdateEmployee extends StatefulWidget {
  UpdateEmployee({super.key});

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  Map<String, dynamic> controllers = {};
  Map arabicToEnglishDataNames = {
    'ID': 'employeeid',
    'الاسم': 'name',
    'الرقم القومي': 'nationalidnumber',
    'الرقم التأميني': 'insurancenumber',
    'المجموعة الوظيفية': 'functionalgroup',
    'المجموعة النوعية': 'jobcategory',
    'المسمى الوظيفي': 'jobtitle',
    'الدرجة الوظيفية': 'degree',
    'العنوان': 'address',
    'النوع': 'gender',
    'الديانة': 'religion',
    'رقم الهاتف': 'phone_number',
    'الحالة من التجنيد': 'military_service_status',
    'الادارة': 'administration',
    'الوظيفة الحالية': 'currentjob',
    'المؤهل': 'qualification',
    'نوع العقد': 'typeofcontract',
    'اخر تقرير': 'report',
    'الحالة من العمل': 'employmentstatus',
    'تاريخ استلام العمل': 'dateofappointment',
    'تاريخ التعيين / التعاقد': 'contractdate',
    'تاريخ الميلاد': 'date_of_birth',
    'تاريخ اخر ترقية': 'dateoflastpromotion',
  };
  Map<String, dynamic> optionsCategories = {
    'functionalgroup': [
      'استشاري',
      'تخصصية',
      'فنية',
      'مكتبية',
      'حرفية',
      'خدمات معاونة'
    ],
    'degree': [
      'عليا',
      'مدير عام',
      'الأولى-أ',
      'الأولى-ب',
      'الثانية-أ',
      'الثانية-ب',
      'الثانية-ج',
      'الثالثة-أ',
      'الثالثة-ب',
      'الثالثة-ج',
      'الرابعة-أ',
      'الرابعة-ب',
      'الرابعة-ج',
      'الخامسة-أ',
      'الخامسة-ب',
      'الخامسة-ج',
      'السادسة-أ',
      'السادسة-ب',
      'السادسة-ج'
    ],
    'gender': ['ذكر', 'أنثى'],
    'religion': ['مسلم', 'مسيحي'],
    'military_service_status': ['معفى', 'أدى الخدمة'],
    'jobcategory': {
      'استشاري': ['مدير عام'],
      'تخصصية': [
        'اقتصاد وتجارة',
        'قانون',
        'إعلام',
        'الأمن',
        'خدمة إجتماعية',
        'تنمية إدارية',
        'هندسية',
        'تمويل ومحاسبة'
      ],
      'مكتبية': [
        'كاتب عقود مشتريات',
        'كاتب سجلات',
        'كاتب سجلات',
        'كاتب شطب',
        'كاتب شئون عاملين',
        'كاتب سكرتارية',
        'كاتب حسابات',
        'محصل',
        'صراف'
      ],
      'فنية': ['هندسة مساعدة', 'خدمة إجتماعية', 'فنون وعمارة', 'زراعة'],
      'حرفية': ['حركة ونقل', 'زراعة وتغذية', 'ورش وآلات'],
      'خدمات معاونة': ['خدمات معاونة']
    },
    'administration': [
      'إيرادات الرسوم والتحصيل',
      'الخزينة',
      'مركز تكنولوجي لخدمة المواطنين',
      'مركز المعلومات والتحول الرقمي',
      'المتابعة الميدانية',
      'الشئون الإدارية',
      'شئون المقر'
          'الأمن',
      'التقييم والمتابعة',
      'الإدارة الهندسية',
      'الشئون القانونية',
      'شئون البيئة',
      'الحسابات',
      'الموارد البشرية',
      'المخازن',
      'العقود والمشتريات',
      'الميزانية',
      'التخطيط والمتابعة'
    ],
    'typeofcontract': [
      'مخابز',
      'محاجر',
      'شاليهات',
      'دواجن وإنتاج حيواني',
      'الأسواق',
      'تجميل ونضافة',
      'عقود مقننة',
      'عقود غير مقننة',
    ],
    'report': [
      'امتياز',
      'كفء',
      'فوق متوسط',
      'متوسط',
      'ضعيف',
    ],
    'employmentstatus': [
      'على رأس العمل',
      'منتدب',
      'معار',
      'إجازة خاصة',
      'رعاية طفل',
      'إيقاف عن العمل',
      'إجازة إستثنائية',
    ],
  };
  Map<String, String?> selectedDropdownValues = {};
  bool employeeAdded = false;
  Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2100),
    );
    return pickedDate;
  }

  @override
  void initState() {
    super.initState();
    initializeDropdownValues();
    arabicToEnglishDataNames.values.forEach((dataName) {
      if (!dataName.toString().contains('date') &&
          !optionsCategories.keys.toList().contains(dataName)) {
        controllers[dataName] = TextEditingController();
      }
    });
  }

  void initializeDropdownValues() {
    optionsCategories.forEach((key, value) {
      selectedDropdownValues[key] = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<DatabaseCubit>().addEmployeeInitial();
    return Scaffold(
        backgroundColor: clr(3),
        appBar: customAppBar('إضافة موظف', context, true),
        body: BlocBuilder<DatabaseCubit, DatabaseState>(
          builder: (context, state) {
            if (state is DatabaseAddingEmployee) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return customContainer(
                  width: 1000,
                  height: double.infinity,
                  child: Column(children: [
                    Center(
                      child: Text('بيانات الموظف',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: arabicToEnglishDataNames.length,
                        itemBuilder: (context, index) {
                          final dataName = arabicToEnglishDataNames.values
                              .toList()[index]
                              .toString();
                          if (dataName.contains('date')) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: customButton(
                                  label: arabicToEnglishDataNames.keys
                                      .toList()[index]
                                      .toString(),
                                  onPressed: () async {
                                    controllers[dataName] =
                                        await selectDate(context);
                                  }),
                            );
                          } else if (optionsCategories.keys
                              .toList()
                              .contains(dataName)) {
                            List<DropdownMenuItem<String>> items = [];
                            String? selectedItem;
                            if (dataName == 'jobcategory') {
                              if (selectedDropdownValues['functionalgroup'] !=
                                  null) {
                                for (var element in optionsCategories[dataName][
                                    selectedDropdownValues[
                                        'functionalgroup']]) {
                                  items.add(DropdownMenuItem(
                                      value: element, child: Text(element)));
                                }
                              }
                            } else {
                              for (var element in optionsCategories[dataName]) {
                                items.add(DropdownMenuItem(
                                    value: element, child: Text(element)));
                              }
                            }
                            return Row(
                              children: [
                                Text(arabicToEnglishDataNames.keys
                                    .toList()[index]),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: DropdownButton<String?>(
                                      isExpanded: true,
                                      value: selectedDropdownValues[dataName],
                                      hint: Text('اختر'),
                                      items: items,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDropdownValues[dataName] =
                                              value;
                                          if (dataName == 'functionalgroup') {
                                            selectedDropdownValues[
                                                    'jobcategory'] =
                                                optionsCategories['jobcategory']
                                                    [value][0];
                                          }
                                          controllers = controllers;
                                        });
                                      }),
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              child: customTextField(
                                  controller: controllers[dataName]!,
                                  label: arabicToEnglishDataNames.keys
                                      .toList()[index]
                                      .toString()),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    customButton(
                        label: 'إضافة',
                        onPressed: () {
                          Map<String, dynamic> employeeData = {};
                          // parsing data
                          for (var element
                              in arabicToEnglishDataNames.values.toList()) {
                            if (optionsCategories.keys
                                .toList()
                                .contains(element)) {
                              employeeData['$element'] =
                                  selectedDropdownValues[element];
                            } else if (!element.toString().contains('date')) {
                              employeeData['$element'] =
                                  controllers['$element']?.text;
                            } else {
                              employeeData['$element'] = controllers['$element']
                                  .toString()
                                  .split(' ')[0];
                            }
                          }
                          employeeData.removeWhere((key, value) =>
                              value == null || value == '' || value == 'null');
                          print(employeeData);
                          context
                              .read<DatabaseCubit>()
                              .updateEmployee(employeeData: employeeData);
                        }),
                  ]));
            }
          },
        ));
  }
}