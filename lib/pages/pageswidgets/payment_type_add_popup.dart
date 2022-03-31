// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPaymentType extends StatefulWidget {
  const AddPaymentType({Key? key}) : super(key: key);

  @override
  _AddPaymentTypeState createState() => _AddPaymentTypeState();
}

class _AddPaymentTypeState extends State<AddPaymentType> {
  final _paymentTypeformKey = GlobalKey<FormState>();
  String errorMessage = 'Please enter an payment type definition.';
  String title = 'Payment Type Definiton';
  String _paymentType = '';

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
                    key: _paymentTypeformKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
                          maxLength: 20,
                          onTap: () {},
                          onSaved: (value) => _paymentType = value!,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return errorMessage;
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
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            _paymentTypeformKey.currentState!.save();

                            if (_paymentTypeformKey.currentState!.validate()) {
                              await saveCahanges(_paymentType);
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

Future saveCahanges(String paymentType) async {
  FirebaseFirestore.instance
      .collection("PaymentTypes")
      .doc(paymentType + "_" + FirebaseAuth.instance.currentUser!.uid)
      .set({
    'TypeName': paymentType,
    'UserID': FirebaseAuth.instance.currentUser!.uid
  });
}
