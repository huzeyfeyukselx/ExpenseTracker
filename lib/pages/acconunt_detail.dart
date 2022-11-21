// ignore_for_file: prefer_const_constructors

import 'package:expensetracer/pages/pageswidgets/account_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/firebase_auth.dart';

class AccountDetail extends StatefulWidget {
  const AccountDetail({Key? key}) : super(key: key);

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FirebaseAuth.instance.currentUser!.displayName.toString(),
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => EditAccount());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListTile(
              title: Text(
                Statics.User['FullName'].toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Name & Surname"),
            ),
            ListTile(
              title: Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("email"),
            ),
            ListTile(
              title: Text(
                FirebaseAuth.instance.currentUser!.phoneNumber ??
                    "000 000 00 00",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Phone Number"),
            ),
          ],
        ),
      ),
    );
  }
}
