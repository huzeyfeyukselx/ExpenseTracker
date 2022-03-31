import 'package:expensetracer/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home.dart';
import 'firebase_auth.dart';

class CheckLogin extends StatelessWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
          ChangeNotifierProvider(create: (context) => TotalAmounCounter()),
        ],
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);
            if (provider.isSigningIn) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const Home();
            } else {
              return const Login();
            }
          },
        ),
      ),
    );
  }
}
