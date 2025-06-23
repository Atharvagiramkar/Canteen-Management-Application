import 'package:canteen_management_app/homepage.dart';
import 'package:canteen_management_app/register.dart';
import 'package:canteen_management_app/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen(); // 🔄 simple animated screen
            }
            if (snapshot.hasData) {
              return Homepage();
            } else {
              return MyRegister();
            }
          },
        ),
      ),
    );
  }
}