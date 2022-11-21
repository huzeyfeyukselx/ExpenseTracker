import 'package:expensetracer/pages/expense_definitions.dart';
import 'package:expensetracer/pages/payment_definitions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../helpers/firebase_auth.dart';
import '../acconunt_detail.dart';

Widget getDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: const Text(
            "Statics.User['FullName'].toString()",
            style: TextStyle(fontSize: 20),
          ),
          accountEmail: const Text(
            "Statics.User['Email'].toString()",
            style: TextStyle(fontSize: 13),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 17, 10, 10),
            child: Text(
              "Statics.User['FullName'].toString()".substring(0, 1),
              style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.list_alt,
                  size: 15,
                ),
                title: const Text(
                  "Expense Definition",
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpenseDefinitons()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.payment_rounded,
                  size: 15,
                ),
                title: const Text(
                  "Payment Definition",
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentDefinitons()));
                },
              ),
              ExpansionTile(
                title: const Text(
                  "Settings",
                  style: TextStyle(fontSize: 15),
                ),
                leading: const Icon(
                  Icons.settings,
                  size: 15,
                ),
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      "Account",
                      style: TextStyle(fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountDetail()));
                    },
                  ),
                ],
              ),
              ListTile(
                title: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 15),
                ),
                leading: const Icon(Icons.logout_rounded),
                onTap: () async {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Align(
                          child: SizedBox(
                            width: 500,
                            child: AlertDialog(
                              title: const Text("Logout!"),
                              content: const Text("Are you want to logout?"),
                              actions: <Widget>[
                                FloatingActionButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                FloatingActionButton(
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.popUntil(context, ModalRoute.withName('/'));
                                  },
                                  backgroundColor: const Color.fromARGB(255, 175, 13, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        )
      ],
    ),
  );
}
