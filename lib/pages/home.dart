// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracer/helpers/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  final formatMask = DateFormat('dd-MM-yyyy');
  final filterFormatMask = DateFormat('MM-yyyy');
  late List<DocumentSnapshot> list;

  double total = 0;
  DateTime filterMountYear = DateTime.now();
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ActionChip(
                  label: Text(
                      Provider.of<TotalAmounCounter>(context).total.toString() +
                          " ₺"),
                  onPressed: () {}),
            )
          ],
        ),
        drawer: getDrawer(context),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.post_add_outlined),
            onPressed: () async {
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection("PaymentTypes")
                  .get();
              if (querySnapshot.docs.isNotEmpty) {
                querySnapshot = await FirebaseFirestore.instance
                    .collection("ExpenseTypes")
                    .get();
              }

              querySnapshot.docs.isNotEmpty
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) => AddExpense())
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Data Error!"),
                          content: Text(
                              "Please check the \"Expende Types\" and \"Payment Types\"."),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
            }),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  months[filterMountYear.month - 1] +
                      " / " +
                      filterMountYear.year.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: filterMountYear,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    ).then((value) {
                      if (value != null && value != filterMountYear) {
                        setState(() {
                          filterMountYear = value;
                        });
                      }
                    });
                  },
                  icon: Icon(
                    Icons.calendar_today_rounded,
                  ),
                )
              ],
            ),
            Expanded(
              child: Card(
                color: Colors.grey.shade300,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Expenses")
                        .where('UserID',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .toString())
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data.docs.length != 0) {
                        list = snapshot.data!.docs;
                        for (int i = (list.length - 1); i > -1; i--) {
                          filterFormatMask.format((list[i].data()
                                          as Map<String, dynamic>)['DateTime']
                                      .toDate()) !=
                                  filterFormatMask.format(filterMountYear)
                              ? list.remove(list[i])
                              : null;
                        }
                        Provider.of<TotalAmounCounter>(context, listen: false)
                            .addAmount(list);

                        return list.isNotEmpty
                            ? ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String, dynamic> data = (list[index]
                                      .data() as Map<String, dynamic>);

                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                          data['ExpenseType'].toString() +
                                              "  (" +
                                              data['Amount'].toString() +
                                              " ₺ " +
                                              data['PaymentType'].toString() +
                                              ")"),
                                      subtitle: Text(formatMask
                                          .format(data['DateTime'].toDate())
                                          .toString()),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          DeleteDialog(list[index], context);
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color:
                                              Color.fromARGB(255, 175, 13, 1),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text("Belong this date has not data!",
                                    style: TextStyle(fontSize: 20)),
                              );
                      } else if (snapshot.data == null ||
                          snapshot.data.docs.length == 0) {
                        return Center(
                            child: Center(
                                child: Text("Data Not Found!",
                                    style: TextStyle(fontSize: 20))));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ),
          ],
        ));
  }
}
