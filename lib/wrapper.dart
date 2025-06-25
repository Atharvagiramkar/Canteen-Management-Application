import 'package:canteen_management_app/homepage.dart';
import 'package:canteen_management_app/login.dart';
import 'package:canteen_management_app/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future<Widget> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 1)); // ⏳ Splash delay

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const MyLogin(); // Not logged in
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      return const MyLogin(); // User not found in Firestore
    }

    final data = userDoc.data()!;
    final role = data['role'] ?? 'customer';

    // Navigate based on role
    if (role == 'owner') {
      return const Homepage(); // Can replace with HomepageOwner()
    } else {
      return const Homepage(); // Can replace with HomepageCustomer()
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _handleNavigation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SplashScreen(); // Show splash during delay + loading
        }

        return snapshot.data!;
      },
    );
  }
}
