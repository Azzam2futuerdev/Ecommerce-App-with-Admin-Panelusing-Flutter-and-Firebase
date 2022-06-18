//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdsadmin/category_wise/category_view.dart';
import 'package:vdsadmin/category_wise/filter_products.dart';
import 'package:vdsadmin/models/data_provider.dart';
import 'package:vdsadmin/search/search.dart';

class Category extends StatefulWidget {
  const Category({Key key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white10.withOpacity(0.95),
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
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          'Top Categories',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18),
        ),
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
                              itemCount: snapshot.data?.docs.length,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 3 / 3.3,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return CategoryView(
                                  snapshot: snapshot.data.docs[index],
                                  onClick: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FilterProduct(
                                                    snapshot: snapshot
                                                        .data.docs[index])));
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: const [
                          CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Loading...',
                            style: TextStyle(fontSize: 18, color: Colors.black),
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
                  padding: EdgeInsets.only(top: 8),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.hasData) {
                      return ListTile(
                        title: Text(
                          '${snapshot.data.docs[index]['tag']}',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(Icons.navigate_next),
                        leading: CachedNetworkImage(
                          imageUrl: snapshot.data.docs[index]['icon'],
                          fit: BoxFit.contain,
                          width: 50,
                          height: 50,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      FilterProduct(
                                          snapshot:
                                              snapshot.data.docs[index])));
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              }),
        ],
      ),
    );
  }
}
