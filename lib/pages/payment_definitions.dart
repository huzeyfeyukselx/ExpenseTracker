// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'pageswidgets/delete_dialog.dart';
import 'pageswidgets/payment_type_add_popup.dart';

class PaymentDefinitons extends StatelessWidget {
  const PaymentDefinitons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Definitons",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.post_add_outlined),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AddPaymentType());
          }),
      body: StreamBuilder<QuerySnapshot>(
          stream: GetPaymentTypes(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data.docs.length != 0) {
              List<DocumentSnapshot> list = snapshot.data!.docs;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text((index + 1).toString() +
                        ")  " +
                        (list[index].data() as Map<String, dynamic>)['TypeName']
                            .toString()),
                    trailing: GestureDetector(
                      onTap: () {
                        DeleteDialog(list[index], context);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 175, 13, 1),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.data == null ||
                snapshot.data.docs.length == 0) {
              return Center(child: Center(child: Text("Data Not Found")));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

Stream<QuerySnapshot> GetPaymentTypes() => FirebaseFirestore.instance
    .collection("PaymentTypes")
    .where('UserID',
        isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
    .snapshots();
