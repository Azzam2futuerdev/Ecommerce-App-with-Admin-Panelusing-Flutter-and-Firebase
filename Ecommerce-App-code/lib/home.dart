//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_pro/carousel_pro.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/components/BNavigation.dart';
import 'package:ecom/fliter_products.dart';
import 'package:ecom/components/category_view.dart';
import 'package:ecom/components/home_products.dart';
import 'package:ecom/profile.dart';
import 'package:ecom/search.dart';
import 'package:ecom/select_region.dart';
import 'package:ecom/services/auth_provider.dart';
import 'package:ecom/services/data_provider.dart';

import 'bot_chart.dart';
import 'components/Banner.dart';
import 'login.dart';
import 'myorders.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> links = [];
  String url;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white10.withOpacity(0.95),
      drawer: buildContainer(context, url),
      appBar: AppBar(
        backgroundColor: Color(0xff6fb840),
        elevation: 1,
        leading: IconButton(
          icon: Image.asset(
            "assets/menu.png",
            width: 20,
            color: Colors.white,
            height: 20,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        titleSpacing: 0,
        title: StreamBuilder<DocumentSnapshot>(
            stream: dataProvider.profile(),
            builder: (context, snapshot) {
              return GestureDetector(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Delivery Address',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 12),
                    ),
                    Text(
                      '${snapshot.data['region']}',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SelectRegion()));
                },
              );
            }),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0).copyWith(top: 2, bottom: 5),
            child: Container(
              padding: EdgeInsets.only(left: 8),
              height: 38,
              // width: 0.75*MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(02)),
                  border: Border.all(color: Colors.white),
                  color: Colors.white),
              child: TextField(
                showCursor: true,
                textAlign: TextAlign.left,
                readOnly: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xffA0CD4A),
                  ),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Color(0xFF666666),
                  ),
                  hintText: "Search your products",
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Search()));
                },
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          SizedBox(height: 1),
          StreamBuilder<QuerySnapshot>(
              stream: dataProvider.banners('slide'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Banners(
                    snapshot: snapshot.data,
                  );
                }
                return Container();
              }),
          Card(
            elevation: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 8, bottom: 12),
                  child: Text(
                    'Shop By Category',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: dataProvider.category(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data?.documents.length,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 3 / 3.3,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return CategoryView(
                                  snapshot: snapshot.data.documents[index],
                                  onClick: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FilterProduct(
                                                    snapshot: snapshot.data
                                                        .documents[index])));
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Loading...',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      );
                    }),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: dataProvider.category(),
              builder: (context, snapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return HomeProducts(
                      snapshot: snapshot.data.documents[index],
                    );
                  },
                );
              }),
          SizedBox(height: 20)
        ],
      ),
      bottomNavigationBar: BNavigation(_scaffoldKey),
    );
  }

  Container buildContainer(BuildContext context, String url) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 110,
              height: 110,
              padding: EdgeInsets.all(4),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Neumorphic(
                style: NeumorphicStyle(
                    depth: 10,
                    color: Colors.white,
                    boxShape: NeumorphicBoxShape.circle(),
                    shadowLightColor: Color(0xff6fb840).withOpacity(0.1)),
                padding: EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70.0),
                  child: UserProvider.profile != null && url!=null
                      ? CachedNetworkImage(
                          imageUrl: UserProvider.profile,
                          fit: BoxFit.contain,
                        )
                      : CircleAvatar(
                          radius: 67,
                          backgroundColor: Color(0xff6fb840),
                          child:
                              Icon(Icons.person, size: 45, color: Colors.white),
                        ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              UserProvider.name ?? 'Guest',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
            child: Center(
                child: Text(
              UserProvider.user.phoneNumber.toString() ?? '+91 xxxxxxxx',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
            )),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: Colors.black,
            ),
            title: Text('Home',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
            },
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person_outline,
              color: Colors.black,
            ),
            title: Text('Account',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Profile()));
            },
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
            title: Text('Orders',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MyOrders()));
            },
            contentPadding:
                EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.support_agent,
              color: Colors.black,
            ),
            title: Text('Contact US',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ChatBot()));
            },
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black,
            ),
          ),
          ListTile(
            title: Text('Sign Out',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              pickImage();
            },
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.black,
            ),
          ),
          ListTile(
            title: Text('Terms of Use',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            onTap: () {},
          ),
          ListTile(
            title: Text('Privacy policy',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void pickImage() {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 34),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.info_outline,
                          size: 65,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Are sure you want to logout?',
                          style: GoogleFonts.poppins(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: MaterialButton(
                                elevation: 0,
                                color: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "NO",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                }),
                          ),
                          SizedBox(width: 10),
                          Container(
                            child: MaterialButton(
                                elevation: 0,
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "YES",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  await auth.signOut();
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Login()));
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
