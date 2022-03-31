// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DeleteDialog(DocumentSnapshot snapshot, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          child: SizedBox(
            width: 500,
            child: AlertDialog(
              title: const Text('Warning!'),
              content: const Text('Are you sure to delete?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                FlatButton(
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await snapshot.reference
                        .delete()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  color: const Color.fromARGB(255, 175, 13, 1),
                ),
              ],
            ),
          ),
        );
      });
}
