import 'package:expensetracer/pages/expense_definitions.dart';
import 'package:expensetracer/pages/payment_definitions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../acconunt_detail.dart';

class GetDrawerMenu extends StatelessWidget {
  const GetDrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              FirebaseAuth.instance.currentUser!.displayName.toString(),
              style: const TextStyle(fontSize: 20),
            ),
            accountEmail: Text(
              FirebaseAuth.instance.currentUser!.email.toString(),
              style: const TextStyle(fontSize: 13),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 17, 10, 10),
              child: Text(
                FirebaseAuth.instance.currentUser!.displayName
                    .toString()
                    .substring(0, 1),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpenseDefinitons()));
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentDefinitons()));
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccountDetail()));
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 15),
                  ),
                  leading: Icon(Icons.logout_rounded),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
