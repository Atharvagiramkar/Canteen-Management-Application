import 'package:canteen_management_app/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes:{'login': (context) => MyLogin()
    }
  ));
}

