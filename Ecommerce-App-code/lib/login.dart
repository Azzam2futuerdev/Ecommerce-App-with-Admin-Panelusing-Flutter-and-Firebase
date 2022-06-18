//@dart=2.9

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:ecom/select_region.dart';
import 'package:ecom/services/auth_provider.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.green,
      body: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset('assets/login.png', width: 300, height: 300)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 32),
                      child: Text("Get Started",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                          "Please enter your mobile number to send the OTP",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0)
                          .copyWith(top: 30, bottom: 30, left: 24, right: 24),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextField(
                          controller: _phone,
                          showCursor: true,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                            hintText: "Phone No.",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    Center(
                      child: MaterialButton(
                          elevation: 0,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 42.0),
                            child: Text("Get OTP",
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 18)),
                          ),
                          onPressed: () {
                            if (_phone.text.length == 10) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OTP(_phone.text)));
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content:
                                      Text('Phone number should be 10 digit')));
                            }
                          }),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OTP extends StatefulWidget {
  final String phone;
  OTP(this.phone);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController _phone = new TextEditingController();
  TextEditingController otp = new TextEditingController();
  String _countryCode = "+91";
  String _smsCode = "";
  String _verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    _phone.text = widget.phone;
    verifyPhone();
    super.initState();
  }

  Future<void> verifyPhone() async {
    try {
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        this._verificationId = verId;
      };
      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        this._verificationId = verId;
      };
      final PhoneVerificationCompleted verifiedSuccess = (credential) async {
        print(credential.providerId + "    --------      AUTO VERIFY");
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException exception) {};

      await _auth.verifyPhoneNumber(
        phoneNumber: this._countryCode + this._phone.text.trim(),
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verificationFailed,
      );
    } catch (e) {
      print("What Was the problem" + e.toString());
    }
  }

  void signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _smsCode.trim());
    _signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            }),
      ),
      body: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                      child: Text("Verify Your Mobile Number",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                    Image.asset('assets/login.png', width: 250, height: 250)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 32),
                      child: Text("Otp Verification",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                          "Please enter OTP sent to your mobile number +91 ${_phone.text}",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: PinCodeTextField(
                        autofocus: true,
                        controller: otp,
                        highlight: true,
                        highlightColor: Colors.black,
                        defaultBorderColor: Colors.black.withOpacity(0.3),
                        hasTextBorderColor: Colors.black,
                        maxLength: 6,
                        pinBoxRadius: 12,
                        onDone: (text) {
                          setState(() {
                            _smsCode = text;
                          });
                        },
                        pinBoxWidth: 45,
                        pinBoxHeight: 45,
                        wrapAlignment: WrapAlignment.spaceAround,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the code? ",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        TextButton(
                            onPressed: verifyPhone,
                            child: Text(
                              "RESEND",
                              style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Center(
                      child: MaterialButton(
                          elevation: 0,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 42.0),
                            child: Text(
                              "LogIn",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                          onPressed: () {
                            if (_smsCode.length == 6) {
                              signIn();
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please enter a valid OTP');
                            }
                          }),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _signInWithCredential(AuthCredential credential) async {
    FirebaseUser user;
    try {
      final authRes = await _auth.signInWithCredential(credential);
      user = authRes.user;
      if (user != null) {
        await UserProvider.getRegion();
        if (UserProvider.pincode != null) {
          await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()));
        } else {
          await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SelectRegion()));
        }
      } else {
        print('ccv');
      }
    } catch (err) {
      setState(() {});
      print(err.toString());
    }
  }
}
