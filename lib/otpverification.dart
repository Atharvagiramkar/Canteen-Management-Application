import 'dart:async';
import 'package:canteen_management_app/components/popup.dart';
import 'package:canteen_management_app/forget.dart';
import 'package:canteen_management_app/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: use_key_in_widget_constructors
class OTPValidation extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _OTPValidationState createState() => _OTPValidationState();
}

class _OTPValidationState extends State<OTPValidation> {
  // ignore: prefer_final_fields
  TextEditingController _otpController = TextEditingController();
  late Timer _timer;
  int _start = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _start = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _canResend = true;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _resendOtp() {
    if (_canResend) {
      startTimer();
      // Add your resend logic here
      // print("OTP Resent!");
    }
  }

  void _validateOtp() {
    final otp = _otpController.text;
    if (otp.length == 6) {
      // print("Validating OTP: $otp");
      // Add validation logic here
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter 6-digit OTP")));
    }
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/otpverification.png', height: 300),
                  SizedBox(height: 32),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "OTP Validation",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Please enter the 6-digit OTP sent to your phone number.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 24),
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: _otpController,
                          onChanged: (value) {},
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeColor: Colors.black,
                            selectedColor: Colors.green,
                            inactiveColor: Colors.grey,
                            fieldOuterPadding: EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _canResend ? _resendOtp : null,
                              child: Text(
                                "Resend OTP",
                                style: TextStyle(
                                  color: _canResend
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "OTP valid up to 00:${_start.toString().padLeft(2, '0')}",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              _validateOtp;
                              showCustomPopup(
                                context: context,
                                icon: Icons.verified_rounded,
                                title: "OTP Validated Successfully",
                                message: "Your OTP is Validated Successfully",
                                primaryBtnText: "Ok",
                                onPrimaryPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResetPassword(),
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Validate",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
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
