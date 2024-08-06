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
  AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  Map<String, dynamic> controllers = {};
  Map arabicToEnglishDataNames = {
    // 'ID': 'employeeid',
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
    'الحالة الاجتماعية': 'maritalstatus',
    'رصيد الاجازات': 'vacationBalance',
    'المستوى': 'role',
    'تاريخ استلام العمل': 'dateofappointment',
    'تاريخ التعيين / التعاقد': 'contractdate',
    'تاريخ الميلاد': 'date_of_birth',
    'تاريخ اخر ترقية': 'dateoflastpromotion',
  };
  Map<String, dynamic> optionsCategories = {
    'functionalgroup': [
      'لا يوجد',
      'استشاري',
      'تخصصية',
      'فنية',
      'مكتبية',
      'حرفية',
      'خدمات معاونة'
    ],
    'degree': [
      'لا يوجد',
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
    'military_service_status': ['لا يوجد', 'معفى', 'أدى الخدمة'],
    'jobcategory': {
      'لا يوجد': ['لا يوجد'],
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
      'لا يوجد',
      'إيرادات الرسوم والتحصيل',
      'الخزينة',
      'مركز تكنولوجي لخدمة المواطنين',
      'مركز المعلومات والتحول الرقمي',
      'المتابعة الميدانية',
      'الشئون الإدارية',
      'شئون المقر',
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
      'التخطيط والمتابعة',
      'رئيس الحي',
      'سكرتير عام الحي',
      'مساعد رئيس حي',
      'الشئون المالية والادارية',
      'العلاقات العامة والإعلام',
      'سكرتارية مكتب رئيس الحي',
      'سكرتارية مكتب سكرتير الحي',
    ],
    // 'qualification': [

    // ],
    'typeofcontract': [
      'لا يوجد',
      'دائم',
      'عقد استعانة',
      'عقد مياومة',
      'مشروع مخابز',
      'مشروع محاجر',
      'مشروع شاليهات',
      'مشروع دواجن وإنتاج حيواني',
      'مشروع الأسواق',
      'مشروع تجميل ونضافة',
      'مشروع عقود مقننة',
      'مشروع عقود غير مقننة',
      'مشروع صندوق الخدمات',
      'اخرى'
    ],
    'report': [
      'لا يوجد',
      'امتياز',
      'كفء',
      'فوق متوسط',
      'متوسط',
      'ضعيف',
    ],
    'employmentstatus': [
      'لا يوجد',
      'على رأس العمل',
      'منتدب',
      'معار',
      'إجازة خاصة',
      'رعاية طفل',
      'إيقاف عن العمل',
      'إجازة إستثنائية',
    ],
    'maritalstatus': ['اعزب/عزباء', 'متزوج/ة', 'ارمل/ة', 'مطلق/ة'],
    'role': ["موظف", "مدير"]
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
    if (pickedDate == null) {
      return DateTime.now();
    } else {
      return pickedDate;
    }
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
    // Initialize selectedDropdownValues for each dropdown
    optionsCategories.forEach((key, value) {
      if (value is List) {
        selectedDropdownValues[key] = value[0];
      } else {
        selectedDropdownValues[key] =
            value[selectedDropdownValues['functionalgroup']][0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // context.read<DatabaseCubit>().addEmployeeInitial();
    return Scaffold(
        backgroundColor: clr(3),
        appBar: customAppBar('إضافة موظف', context, true),
        body: BlocBuilder<DatabaseCubit, DatabaseState>(
          builder: (context, state) {
            return customContainer(
                width: 1000,
                height: double.infinity,
                child: Column(children: [
                  Center(
                    child: Text('بيانات الموظف',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  state is DatabaseAddingEmployee
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                        )
                      : state is DatabaseAddedEmployee
                          ? Icon(Icons.check_box)
                          : Container(),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: arabicToEnglishDataNames.length,
                      itemBuilder: (context, index) {
                        final dataName = arabicToEnglishDataNames.values
                            .toList()[index]
                            .toString();
                        String selectedgroup =
                            optionsCategories['functionalgroup'][0];
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
                            for (var element in optionsCategories[dataName]
                                [selectedDropdownValues['functionalgroup']]) {
                              selectedItem = optionsCategories[dataName][
                                  selectedDropdownValues['functionalgroup']][0];
                              items.add(DropdownMenuItem(
                                  value: element, child: Text(element)));
                            }
                          } else {
                            for (var element in optionsCategories[dataName]) {
                              selectedItem = optionsCategories[dataName][0];
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
                                child: DropdownButton(
                                    isExpanded: true,
                                    value: selectedDropdownValues[dataName],
                                    items: items,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDropdownValues[dataName] =
                                            value;
                                        if (dataName == 'functionalgroup') {
                                          selectedDropdownValues[
                                                  'jobcategory'] =
                                              optionsCategories['jobcategory'][
                                                  selectedDropdownValues[
                                                      'functionalgroup']][0];
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
                            if (employeeData[element] == 'null') {
                              employeeData[element] = DateTime.now().toString();
                            }
                          }
                        }
                        // change the role to contain the administration
                        if (employeeData['administration'] ==
                            'الموارد البشرية') {
                          employeeData['role'] = employeeData['administration'];
                        } else if (!employeeData['administration']
                            .toString()
                            .contains("الحي")) {
                          employeeData['role'] = employeeData['role'] +
                              employeeData['administration'];
                        }

                        print(employeeData);
                        context
                            .read<DatabaseCubit>()
                            .addEmployee(employeeData: employeeData);
                      }),
                ]));
          },
        ));
  }
}
