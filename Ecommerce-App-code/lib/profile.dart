//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/services/auth_provider.dart';
import 'package:ecom/services/data_provider.dart';
import 'edit_account.dart';
import 'login.dart';
import 'myorders.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Icon(
              Icons.edit,
              color: Colors.white,
            )
          ],
          centerTitle: true,
          title: Text(
            "My Account",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w500),
          )),
      body: StreamBuilder<DocumentSnapshot>(
          stream: dataProvider.profile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          padding: EdgeInsets.all(4),
                          child: Neumorphic(
                            style: NeumorphicStyle(
                                depth: 9,
                                boxShape: NeumorphicBoxShape.circle(),
                                shadowLightColor: Colors.transparent),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(70.0),
                              child: snapshot.data['profile'] != null &&
                                      snapshot.data['profile'].isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: snapshot.data['profile'],
                                      fit: BoxFit.cover,
                                    )
                                  : CircleAvatar(
                                      radius: 67,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person,
                                          size: 45, color: Color(0xff6fb840)),
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0)
                              .copyWith(top: 10, bottom: 0),
                          child: Center(
                              child: Text(
                            snapshot.data['name'] ?? 'Guest',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0)
                              .copyWith(top: 0, bottom: 40),
                          child: Center(
                              child: Text(
                            UserProvider.user.phoneNumber ?? '+91 XXX',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white),
                          )),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(32),
                              topLeft: Radius.circular(32))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.person_outline,
                              color: Colors.black,
                            ),
                            title: Text('Edit Account',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditAccount(snapshot.data)));
                            },
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16.0),
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
                                      builder: (BuildContext context) =>
                                          MyOrders()));
                            },
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16.0),
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
                              // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ContactUS()));
                            },
                            trailing: Icon(
                              Icons.navigate_next,
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.rate_review_outlined,
                              color: Colors.black,
                            ),
                            title: Text('Review US',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16)),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16.0),
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
                    ),
                  )
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
                            child: MaterialButton(
                                elevation: 0,
                                color: Color(0xfff6615e),
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
                          Container(
                            width: 200,
                            child: MaterialButton(
                                elevation: 0,
                                color: Color(0xfff6615e),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
