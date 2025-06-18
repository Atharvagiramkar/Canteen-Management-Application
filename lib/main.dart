import 'package:canteen_management_app/forget.dart';
import 'package:canteen_management_app/login.dart';
import 'package:canteen_management_app/register.dart';
import 'package:canteen_management_app/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'splash',
    routes:{
      'splash':(context) => SplashScreen(),
      'login': (context) => MyLogin(),
      'register': (context) => MyRegister(),
      'forget': (context) => ForgetPassword(),
    }
  ));
}

