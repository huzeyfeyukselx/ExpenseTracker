// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
          child: Center(
        child: GestureDetector(
          onTap: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.login();
          },
          child: SizedBox(
            height: 40.0,
            width: 200.0,
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.grey,
              color: Colors.white,
              elevation: 7.0,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    "Sign in with  ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Image(
                    image: AssetImage(
                      'assets/icons/googleicon.png',
                    ),
                  ),
                ],
              )),
            ),
          ),
        ),
      )),
    );
  }
}
