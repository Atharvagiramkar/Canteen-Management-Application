import 'package:canteen_management_app/forget.dart';
import 'package:canteen_management_app/homepage.dart';
import 'package:canteen_management_app/login.dart';
import 'package:canteen_management_app/otpverification.dart';
import 'package:canteen_management_app/register.dart';
import 'package:canteen_management_app/resetpassword.dart';
import 'package:canteen_management_app/splash.dart';
import 'package:canteen_management_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'wrapper',
      routes: {
        'wrapper': (context) => Wrapper(),
        'splash': (context) => SplashScreen(),
        'login': (context) => MyLogin(),
        'register': (context) => MyRegister(),
        'forget': (context) => ForgetPassword(),
        'otpvalidation': (context) => OTPValidation(),
        'resetpassword': (context) => ResetPassword(),
        'homepage': (context) => Homepage(),
      },
    ),
  );
}
