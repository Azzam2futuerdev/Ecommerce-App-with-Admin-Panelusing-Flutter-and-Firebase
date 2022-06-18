import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdsadmin/banners/banner.dart';
import 'package:vdsadmin/billing/bill.dart';
import 'package:vdsadmin/category/category1.dart';
import 'package:vdsadmin/category_wise/category.dart';
import 'package:vdsadmin/database/add_item_to_db.dart';
import 'package:vdsadmin/example.dart';
import 'package:vdsadmin/gridView/grid_vw.dart';
import 'package:vdsadmin/home/loginpage.dart';
import 'package:vdsadmin/notification/notifyhome.dart';
import 'package:vdsadmin/orders/orders.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String username;
  late String fullname;

  @override
  void initState() {
    getToken();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
    );
    //onBackgroundMessage: myBackgroundMessageHandler,
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    super.initState();
    name();
  }

  void name() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      fullname = prefs.getString('fullname')!;
    });
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    prefs.setString('username', username);
    prefs.setString('fullname', fullname);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => Login()));
  }

  String token = '';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void getToken() async {
    token = (await firebaseMessaging.getToken())!;
    CollectionReference reference =
        FirebaseFirestore.instance.collection('Users');
    final status = await OneSignal.shared.getDeviceState();
    final String? tokenId = status?.userId;
    print('token ID is : $tokenId');
    try {
      reference.doc(username).update({
        'OneSignalTokenID': tokenId,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text(
              'Vishal Departmental Store',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Admin Panel',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0),
            ),
          ],
        ),
        backgroundColor: Color(0xffF3AB0D),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.get_app),
            onPressed: () {
              getToken();
              print(token);
            },
          ),
          IconButton(icon: Icon(Icons.logout), onPressed: _logOut)
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: <Widget>[
                    Image.asset('images/imageDashboard.png'),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  MaterialButton(
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: const Color(0xFF003D64),
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(0.0, 10.0),
                                      blurRadius: 10.0)
                                ]),
                            alignment: FractionalOffset.centerRight,
                            child: const Image(
                              image: AssetImage(
                                'images/1.png',
                              ),
                              height: 200,
                              width: 190,
                            ),
                          ),
                        ),
                        // Container(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Start Billing',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Container(
                                height: 40.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: const Color(0xFF00578D),
                                ),
                                child: Center(
                                  child: RichText(
                                    text: const TextSpan(
                                      text: 'Click Here',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          ),
                                          alignment:
                                              PlaceholderAlignment.middle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Bill(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFFE44E4F),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0.0, 10.0),
                                          blurRadius: 10.0)
                                    ]),
                                child: Container(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Image.asset(
                                    'images/4.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      'Add items',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.black26,
                                      ),
                                      child: Center(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: RichText(
                                              text: const TextSpan(
                                                text: 'to stock',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                    ),
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ShopRegister(),
                            ),
                          ),
                        ),

                        // cards(
                        //   colour: const Color(0xFFE44E4F),
                        //   img: 'images/4.png',
                        //   width: MediaQuery.of(context).size.width * 0.4,
                        //   height: MediaQuery.of(context).size.height * 0.4,
                        //   title: 'Add items',
                        //   subtitle: 'to stock',
                        //   input: const ShopRegister(),
                        // ),
                        MaterialButton(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFF6674F1),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0.0, 10.0),
                                          blurRadius: 10.0)
                                    ]),
                                child: Container(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Image.asset(
                                    'images/5.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                      text: const TextSpan(
                                        text: 'Category',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.black26,
                                      ),
                                      child: Center(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: RichText(
                                              text: const TextSpan(
                                                text: 'and sub-Category',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                    ),
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Category1(),
                            ),
                          ),
                        ),

                        // cards(
                        //   colour: const Color(0xFF6674F1),
                        //   img: 'images/5.png',
                        //   width: MediaQuery.of(context).size.width * 0.4,
                        //   height: MediaQuery.of(context).size.height * 0.4,
                        //   title: ' Manage Category',
                        //   subtitle: 'and sub-Category',
                        //   input: Category1(),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFF08B499),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0.0, 10.0),
                                          blurRadius: 10.0)
                                    ]),
                                child: Container(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Image.asset(
                                    'images/orders.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      'Orders',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.black26,
                                      ),
                                      child: Center(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: RichText(
                                              text: const TextSpan(
                                                text: 'Online and offline',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                    ),
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Orderspage(),
                            ),
                          ),
                        ),
                        MaterialButton(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFFE67E49),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0.0, 10.0),
                                          blurRadius: 10.0)
                                    ]),
                                child: Container(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Image.asset(
                                    'images/banner.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                      text: const TextSpan(
                                        text: 'Banners',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BannerDisplay(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFF02D4F9),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0.0, 10.0),
                                          blurRadius: 10.0)
                                    ]),
                                child: Container(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Image.asset(
                                    'images/8.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                      'Notification',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Notificationpage(),
                            ),
                          ),
                        ),
                        MaterialButton(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFFBA779A),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0.0, 10.0),
                                          blurRadius: 10.0)
                                    ]),
                                child: Container(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Image.asset(
                                    'images/9.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                      text: const TextSpan(
                                        text: 'Blank',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.black26,
                                      ),
                                      child: Center(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: RichText(
                                              text: const TextSpan(
                                                text: '',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                    ),
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Example(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFF02D4F9),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0.0, 10.0),
                                          blurRadius: 10.0)
                                    ]),
                                child: Container(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Image.asset(
                                    'images/6.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                      'Grid view',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GridScreen(),
                            ),
                          ),
                        ),
                        MaterialButton(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: const Color(0xFFBA779A),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0.0, 10.0),
                                          blurRadius: 10.0)
                                    ]),
                                child: Container(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Image.asset(
                                    'images/7.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                      text: const TextSpan(
                                        text: 'Category',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.black26,
                                      ),
                                      child: Center(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: RichText(
                                              text: const TextSpan(
                                                text: 'Products',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.white,
                                                    ),
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Category(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DraggableScrollableSheet(
                initialChildSize: 0.1,
                minChildSize: 0.1,
                maxChildSize: 0.4,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                        color: Color(0xffF3AB0D),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              height: 10,
                              width: 100,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.grey,
                              child: const Image(
                                image: AssetImage(
                                  'images/1.png',
                                ),
                                height: 200,
                                width: 190,
                              ),
                            ),
                          ),
                          Text(
                            "Hii, $fullname",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
