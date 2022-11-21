// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  final dateTime;
  final paymentTypes;
  final expenseTypes;

  const AddExpense({Key? key, this.dateTime, this.expenseTypes, this.paymentTypes}) : super(key: key);

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _expenseformKey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  final String amountErrorMessage = 'Please enter an amount.';
  final String title = 'Expense Detail';
  late String paymentType, exenseType, date;
  int amount = 0;
  final formatMask = DateFormat('dd-MM-yyyy');
  late DateTime currentDate;
  List<String> expenseList = <String>[];
  List<String> paymentList = <String>[];
  @override
  void initState() {
    super.initState();
    currentDate = widget.dateTime;
  }

  Future<bool> getTypes() async {
    if (paymentList.isEmpty) {
      for (int i = 0; i < widget.paymentTypes.docs.length; i++) {
        paymentList.add(widget.paymentTypes.docs[i]['TypeName']);
      }

      paymentType = paymentList.isEmpty ? 'Diğer' : paymentList[0];

      expenseList.clear();

      for (int i = 0; i < widget.expenseTypes.docs.length; i++) {
        expenseList.add(widget.expenseTypes.docs[i]['TypeName']);
      }
      exenseType = expenseList.isEmpty ? 'Diğer' : expenseList[0];

      return true;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    getTypes();
    return Align(
      child: SizedBox(
        width: 500,
        child: SimpleDialog(
          title: Text(title),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _expenseformKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: DropdownButton(
                            value: paymentType,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: paymentList.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                paymentType = newValue!;
                              });
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.only(top: 16),
                                child: DropdownButton(
                                  value: exenseType,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: expenseList.map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      exenseType = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onSaved: (value) => amount = value == "" ? 0 : int.parse(value!),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 16),
                              child: const Text(
                                "₺",
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                color: Colors.grey.shade300,
                                child: Text(
                                  formatMask.format(currentDate),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey.shade600,
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.calendar_today_rounded,
                                ),
                                iconSize: 25,
                                color: Colors.white,
                                splashColor: Colors.grey[300],
                                onPressed: () async {
                                  final DateTime? selected = await showDatePicker(
                                    context: context,
                                    initialDate: currentDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );

                                  if (selected != null && selected != currentDate) {
                                    setState(() {
                                      currentDate = selected;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FloatingActionButton(
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            _expenseformKey.currentState!.save();

                            if (_expenseformKey.currentState!.validate()) {
                              await saveCahanges(exenseType, paymentType, currentDate, amount);
                              Navigator.pop(context);
                            }
                          },
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future saveCahanges(String expenseType, paymentType, DateTime date, int amount) async {
  var id = FirebaseFirestore.instance.collection('Expenses').doc().id;
  FirebaseFirestore.instance.collection("Expenses").doc(id).set({
    'Amount': amount,
    'UserID': FirebaseAuth.instance.currentUser!.uid,
    'DateTime': date,
    'ExpenseType': expenseType,
    'PaymentType': paymentType,
  });
}
