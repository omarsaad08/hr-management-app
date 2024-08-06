// presentation/components/custom_sub_trans.dart
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_app/business_logic/cubit/transactions_cubit.dart';
import 'package:hr_management_app/presentation/components/customButton.dart';
import 'theme.dart';

class custom_sub_trans extends StatefulWidget {
  String? sub_title1;
  String? sub_title2;
  List? trans_options;
  final List notification_options = ['رئيس الحي', 'مدير الموظف', 'الموظف'];
  final String type;
  custom_sub_trans(
      {Key? key,
      this.sub_title1,
      this.sub_title2,
      required this.type,
      this.trans_options})
      : super(key: key);

  @override
  State<custom_sub_trans> createState() => _custom_sub_transState();
}

class _custom_sub_transState extends State<custom_sub_trans> {
  TextEditingController idController = TextEditingController();
  DateTimeRange? selectedRange;
  DateTime? selectedDate;

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

  int? selectedOption;
  List<bool> notificationIscheckedlist = [];
  List<bool> statisticsIsCheckedList = [];
  @override
  void initState() {
    super.initState();
    selectedOption = 0;
    statisticsIsCheckedList =
        List.generate(widget.trans_options!.length, (index) => false);
    notificationIscheckedlist =
        List.generate(widget.notification_options.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final transactionsCubit = context.read<TransactionsCubit>();
    transactionsCubit.emitInitial();
    void handle_transaction() async {
      Map<String, dynamic> data = {};
      selectedDate = selectedDate ?? DateTime.now();
      selectedDate.toString();
      switch (widget.type) {
        case 'bonuses':
          data = {
            "employeeID": int.parse(idController.text),
            "promotionDate": selectedDate.toString(),
            "previousSalary": 50000,
            "newSalary": 60000
          };
          break;
        case 'promotions':
          data = {
            "employeeID": int.parse(idController.text),
            "previousDegree": "B",
            "newDegree": "A",
            "promotionDate": selectedDate.toString(),
            "previousSalary": 50000,
            "newSalary": 60000
          };
          break;
        case 'penalties':
          data = {
            "employeeID": int.parse(idController.text),
            "dateOfPenalty": selectedDate.toString(),
            // "penaltyDescription": "Late submission of project report"
          };
          break;
        case 'vacations':
          data = {
            "employeeID": int.parse(idController.text),
            "startDate": selectedRange!.start.toString().split(' ')[0],
            "endDate": selectedRange!.end.toString().split(' ')[0],
            "duration": selectedRange!.duration.inDays + 1,
            "typeofvacation": widget.trans_options![selectedOption!],
          };
          break;
        default:
      }
      transactionsCubit.newTransaction(widget.type, data);
    }

    Widget checkBoxes(List options, {bool radio = false}) {
      List<Container> checkboxes = [];

      for (int i = 0; i < options.length; i++) {
        checkboxes.add(Container(
          width: 200,
          child: !radio
              ? CheckboxListTile(
                  value: widget.type != 'statistics'
                      ? notificationIscheckedlist[i]
                      : statisticsIsCheckedList[i],
                  onChanged: (newbool) {
                    setState(() {
                      widget.type != 'statistics'
                          ? notificationIscheckedlist[i] = newbool!
                          : statisticsIsCheckedList[i] = newbool!;
                    });
                  },
                  activeColor: clr(2),
                  checkColor: clr(4),
                  title: Text(options[i]),
                  controlAffinity: ListTileControlAffinity.leading,
                )
              : RadioListTile<int>(
                  value: i,
                  groupValue: selectedOption,
                  onChanged: (int? value) {
                    setState(() {
                      selectedOption = value;
                      print(
                          'Selected option: ${widget.trans_options![selectedOption!]}');
                    });
                  },
                  activeColor: clr(2),
                  title: Text(options[i]),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
        ));
      }
      return Wrap(
        children: checkboxes,
      );
    }

    return Scaffold(
      backgroundColor: clr(3),
      body: Center(
        child: Container(
          width: 800.0,
          height: 600.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.0),
            color: clr(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(left: 40, right: 40, top: 30),
            child: Directionality(
                textDirection: TextDirection.rtl,
                child: BlocBuilder<TransactionsCubit, TransactionsState>(
                    builder: (context, state) {
                  if (state is MakingTransaction) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        state is TransactionDone
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(state.message),
                                  Icon(Icons.check_box)
                                ],
                              )
                            : state is TransactionError
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(state.message),
                                      Icon(Icons.error_rounded)
                                    ],
                                  )
                                : Text(''),
                        Row(
                          children: [
                            Text(
                              'كود الموظف ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '*',
                              style: TextStyle(
                                color: clr(2),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          child: TextFormField(
                            controller: idController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  gapPadding: 8,
                                  borderSide: BorderSide(width: 30)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        widget.type == 'vacations'
                            ? customButton(
                                label: 'اختيار تاريخ الاجازة',
                                onPressed: () async {
                                  dateTimeRangePicker();
                                  print(selectedRange);
                                })
                            : widget.type != 'statistics'
                                ? customButton(
                                    label: 'اختيار التاريخ',
                                    onPressed: () async {
                                      selectedDate = await selectDate(context);
                                      print(selectedDate);
                                    })
                                : Container(),
                        SizedBox(height: 10),
                        widget.sub_title1 != null && widget.type != 'penalties'
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: [
                                    Text(
                                      widget.sub_title1!, // نوع الترقية
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: TextStyle(
                                        color: clr(2),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        widget.sub_title1 != null &&
                                widget.trans_options != null
                            ? checkBoxes(widget.trans_options!,
                                radio: widget.type != 'statistics')
                            : Container(),
                        widget.sub_title2 != null
                            ? Row(
                                children: [
                                  Text(
                                    widget.sub_title2!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '*',
                                    style: TextStyle(
                                      color: clr(2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        widget.sub_title2 != null
                            ? checkBoxes(
                                widget.notification_options,
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: customButton(
                                  label: 'تم',
                                  onPressed: () {
                                    handle_transaction();
                                  })),
                        ),
                      ],
                    );
                  }
                })),
          ),
        ),
      ),
    );
  }
}
