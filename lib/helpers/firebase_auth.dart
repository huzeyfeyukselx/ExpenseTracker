// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class Statics {
  static var User;
}

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  late bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }
  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      isSigningIn = false;
    }
  }

  Future checkAndSaveUser() async {
    var id = FirebaseAuth.instance.currentUser!.uid;
    var name = FirebaseAuth.instance.currentUser!.displayName;
    var email = FirebaseAuth.instance.currentUser!.email;
    Statics.User =
        await FirebaseFirestore.instance.collection("Users").doc(id).get();

    if (!(Statics.User.exists)) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .set({'FullName': name, 'Phone': "5555555555", 'Email': email});
      Statics.User =
          await FirebaseFirestore.instance.collection("Users").doc(id).get();
    }
  }

  void logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}

class TotalAmounCounter with ChangeNotifier {
  double _total = 0;
  final filterFormatMask = DateFormat('MM-yyyy');

  double get total => _total;
  set total(double total) => _total = total;

  void addAmount(List<DocumentSnapshot> snapshot) {
    total = 0;
    snapshot.isNotEmpty
        ? snapshot.forEach((element) {
            _total += element['Amount'];
          })
        : _total = 0;

    notifyListeners();
  }

  List<DocumentSnapshot<Object?>> getList(
      List<DocumentSnapshot> list, DateTime datetime) {
    for (int i = (list.length - 1); i > -1; i--) {
      filterFormatMask.format(
                  (list[i].data() as Map<String, dynamic>)['DateTime']
                      .toDate()) !=
              filterFormatMask.format(datetime)
          ? list.remove(list[i])
          : null;
    }
    addAmount(list);

    notifyListeners();
    return list;
  }
}
