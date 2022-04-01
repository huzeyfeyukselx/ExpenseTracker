// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final _expenseformKey = GlobalKey<FormState>();
  late String fullName;
  late String phoneNumber;

  bool cont = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        width: 500,
        child: SimpleDialog(
          title: const Text('Account Edit'),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _expenseformKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
                          maxLength: 50,
                          onTap: () {},
                          onSaved: (value) => fullName = value!,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name.';
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          onTap: () {},
                          onSaved: (value) => phoneNumber = value!,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone.';
                            } else {
                              return null;
                            }
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
                            'Save',
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
