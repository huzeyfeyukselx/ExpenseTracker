// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pageswidgets/delete_dialog.dart';
import 'pageswidgets/drawer_menu.dart';
import 'pageswidgets/expense_add_popup.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String title = 'Expense Tracker';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        drawer: const GetDrawerMenu(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.post_add_outlined),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AddExpense());
            }),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Expenses")
                .where('UserID',
                    isEqualTo:
                        FirebaseAuth.instance.currentUser!.uid.toString())
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<DocumentSnapshot> list = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data =
                        (list[index].data() as Map<String, dynamic>);
                    final formatMask = DateFormat('dd-MM-yyyy');
                    return Card(
                      child: ListTile(
                        title: Text(data['ExpenseType'].toString() +
                            "  (" +
                            data['Amount'].toString() +
                            " ₺)"),
                        subtitle: Text(data['PaymentType'].toString() +
                            " - " +
                            formatMask
                                .format(data['DateTime'].toDate())
                                .toString()),
                        trailing: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext buildContext) {
                                  return DeleteDialog(list[index], context);
                                });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 175, 13, 1),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
