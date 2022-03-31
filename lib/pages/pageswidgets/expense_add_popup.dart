// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _expenseformKey = GlobalKey<FormState>();
  String amountErrorMessage = 'Please enter an amount.';
  String title = 'Expense Detail';
  late String paymentType, epenseType, date, amount;

  @override
  Widget build(BuildContext context) {
    var querySnapshot = FirebaseFirestore.instance
        .collection("PaymentTypes")
        .where('UserID',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
        .snapshots();

    final allData = querySnapshot.map((doc) => doc.docs).toList();
    List<String> list = <String>[];

    paymentType = "list[0]";

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
                          padding: EdgeInsets.only(top: 16),
                          child: DropdownButton(
                            value: paymentType,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: list.map((String item) {
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
                                padding: EdgeInsets.only(top: 16),
                                child: DropdownButton(
                                  value: paymentType,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: list.map((String item) {
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
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onSaved: (value) => amount = value!,
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
                        TextFormField(
                          maxLength: 50,
                          onTap: () {},
                          onSaved: (value) => date = value!,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {},
                          color: Colors.green,
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
