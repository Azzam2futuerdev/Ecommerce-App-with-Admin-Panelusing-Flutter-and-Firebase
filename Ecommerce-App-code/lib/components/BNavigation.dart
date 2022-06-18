//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/cart.dart';
import 'package:ecom/category.dart';
import 'package:ecom/profile.dart';
import 'package:ecom/search.dart';
import 'package:ecom/services/data_provider.dart';

import '../home.dart';

class BNavigation extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const BNavigation(this.scaffoldKey);

  @override
  _BNavigationState createState() => _BNavigationState();
}

class _BNavigationState extends State<BNavigation> {
  static int index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: index,
      iconSize: 25,
      onTap: (v) {
        if (v == 0 && index != v) {
          index = v;
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => HomeScreen(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 10),
            ),
          );
        }
        if (v == 1 && index != v) {
          index = v;
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => Category(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 10),
            ),
          );
        }
        if (v == 2 && index != v) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => Search(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 10),
            ),
          );
        }
        if (v == 3 && index != v) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => Cart(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 10),
            ),
          );
        }
        if (v == 4 && index != v) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => Profile(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 10),
            ),
          );
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: Colors.grey,
          ),
          activeIcon: Icon(
            Icons.home_outlined,
            color: Colors.green,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.apps_outlined,
            color: Colors.grey,
          ),
          activeIcon: Icon(
            Icons.apps_outlined,
            color: Colors.green,
          ),
          label: 'Category',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search_outlined,
            color: Colors.grey,
          ),
          activeIcon: Icon(
            Icons.search_outlined,
            color: Colors.green,
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: StreamBuilder<QuerySnapshot>(
              stream: dataProvider.cart(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.documents.length > 0
                      ? GestureDetector(
                          child: Container(
                            height: 30,
                            width: 30,
                            padding: EdgeInsets.only(left: 0),
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 6,
                                    child: Icon(Icons.shopping_cart_outlined,
                                        color: Colors.grey)),
                                Positioned(
                                    top: 1,
                                    right: 0,
                                    left: 12,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 1,
                                              color: Colors.grey.shade500)
                                        ],
                                      ),
                                      child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Color(0xff32CC34),
                                          child: Text(
                                              '${snapshot.data.documents.length}',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    )),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => Cart(),
                                transitionsBuilder: (c, anim, a2, child) =>
                                    FadeTransition(opacity: anim, child: child),
                                transitionDuration: Duration(milliseconds: 10),
                              ),
                            );
                          },
                        )
                      : GestureDetector(
                          child: Icon(Icons.shopping_cart_outlined,
                              size: 25, color: Colors.grey.shade500),
                          onTap: () {
                            // Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Cart()));
                          });
                }
                return GestureDetector(
                    child: Icon(Icons.shopping_cart_outlined,
                        size: 25, color: Colors.grey.shade500),
                    onTap: () {
                      // Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => Cart()));
                    });
              }),
          activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: <Color>[
                    Colors.greenAccent[200],
                    Colors.blueAccent[200]
                  ],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: Icon(
                Icons.shopping_bag_outlined,
              )),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            color: Colors.grey,
          ),
          activeIcon: Icon(
            Icons.person_outline,
            color: Colors.green,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
