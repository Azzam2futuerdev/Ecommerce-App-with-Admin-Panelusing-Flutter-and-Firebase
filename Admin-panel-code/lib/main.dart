// ignore_for_file: unnecessary_const

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdsadmin/billing/startbilling.dart';
import 'package:vdsadmin/category/category.dart';
import 'package:vdsadmin/category/category1.dart';
import 'package:vdsadmin/example.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vdsadmin/home/splashscreen.dart';
import 'constant.dart';
import 'database/add_item_to_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool user = false;

  @override
  void initState() {
    super.initState();
    _initCheck();
    configOneSignel();
  }

  void configOneSignel() {
    OneSignal.shared.setAppId('d43fa4f9-2fa5-48a3-a184-49636c9d96c5');
  }

  void _initCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('user') != null) {
      setState(() {
        user = prefs.getBool('user')!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Color(0xffF5F6F8),
        fontFamily: "Nunito",
      ),
      title: 'Shared Preference',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(user),
    );
  }
}
