import 'package:canteen_management_app/forget.dart';
import 'package:canteen_management_app/login.dart';
import 'package:canteen_management_app/components/popup.dart';
import 'package:canteen_management_app/otpverification.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Your action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/resetpassword.png',
                      height: 300,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 30,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Please Enter your New Password",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 20),
                          // ✅ Email Field
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "New Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: const Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Password!';
                              }
                              if (value.length < 6 || value.length > 32) {
                                return 'Password Length should be between 6 to 32 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: const Icon(Icons.lock),
                            ), 
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Password!';
                              }
                              if (value.length < 6 || value.length > 32) {
                                return 'Password Length should be between 6 to 32 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Navigator.of(context).push(const OTPVerification(5));
                                  showCustomPopup(
                                    context: context,
                                    icon: Icons.lock_reset,
                                    title: "Reset Password",
                                    message:
                                        "Your Password is Reset to New Password",
                                    primaryBtnText: "Ok",
                                    onPrimaryPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyLogin(),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
