import 'package:flutter/material.dart';
import 'dart:async';

import 'package:vdsadmin/home/dashboard.dart';
import 'package:vdsadmin/home/loginpage.dart';

class SplashScreen extends StatefulWidget {
  final bool user;
  SplashScreen(this.user);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (c) => widget.user ? Dashboard() : Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF3AB0D),
        body: Center(
          child: Text(
            "Vishal. Departmental. Store",
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ));
  }
}
