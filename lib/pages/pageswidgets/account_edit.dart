// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/firebase_auth.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final _expenseformKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  late String fullName;
  late String phoneNumber;

  bool cont = false;

  @override
  void initState() {
    // TODO: implement initState
    _name.text = Statics.User['FullName'].toString();
    _phone.text = Statics.User['Phone'].toString();
  }

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
                          controller: _name,
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
                          controller: _phone,
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
                          onPressed: () async {
                            await saveCahanges(_name.text, _phone.text);
                            Navigator.pop(context);
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

Future saveCahanges(String name, String phone) async {
  var id = FirebaseAuth.instance.currentUser!.uid;
  var email = FirebaseAuth.instance.currentUser!.email;

  await FirebaseFirestore.instance
      .collection("Users")
      .doc(id)
      .set({'FullName': name, 'Phone': phone, "Email": email});
  Statics.User =
      await FirebaseFirestore.instance.collection("Users").doc(id).get();
}
