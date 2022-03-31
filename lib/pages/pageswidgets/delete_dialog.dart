// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget DeleteDialog(DocumentSnapshot snapshot, BuildContext context) {
  return Align(
    child: SizedBox(
      width: 500,
      child: SimpleDialog(
        title: const Text('Are you sure to delete?'),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: <Widget>[
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
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await snapshot.reference.delete();
                          Navigator.pop(context);
                        },
                        color: Colors.red,
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
