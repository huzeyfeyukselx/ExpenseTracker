// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddExpenseType extends StatefulWidget {
  @override
  _AddExpenseTypeState createState() => _AddExpenseTypeState();
}

class _AddExpenseTypeState extends State<AddExpenseType> {
  final _expenseTypeformKey = GlobalKey<FormState>();
  String errorMessage = 'Please enter an expense type definition.';
  String title = 'Expense Type Definiton';
  String _expenseType = '';

  @override
  Widget build(BuildContext context) {
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
                    key: _expenseTypeformKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
                          maxLength: 20,
                          onTap: () {},
                          onSaved: (value) => _expenseType = value!,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return errorMessage;
                            } else
                              return null;
                          },
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
                          onPressed: () async {
                            _expenseTypeformKey.currentState!.save();

                            if (_expenseTypeformKey.currentState!.validate()) {
                              await saveCahanges(_expenseType);
                              Navigator.pop(context);
                            }
                          },
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

Future saveCahanges(String expenseType) async {
  FirebaseFirestore.instance.collection("ExpenseTypes").doc(expenseType).set({
    'TypeName': expenseType,
    'UserID': FirebaseAuth.instance.currentUser!.uid
  });
}
