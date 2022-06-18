//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdsadmin/search/product_details.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool loading = false;
  String value = '';
  String searchKey;
  Stream streamQuery;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6fb840),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
        title: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 4),
          child: Container(
            padding: EdgeInsets.only(left: 8),
            height: 38,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white),
            child: TextField(
              onChanged: (v) {
                setState(() {
                  value = v;
                  searchKey = v;
                  streamQuery = FirebaseFirestore.instance
                      .collection('Col-Name')
                      .where('fieldName', isGreaterThanOrEqualTo: searchKey)
                      .where('fieldName', isLessThan: searchKey + 'z')
                      .snapshots();
                });
              },
              showCursor: true,
              autofocus: true,
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search_rounded),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Color(0xFF666666),
                ),
                hintText: "Search your product",
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Products')
              .where('name', isGreaterThanOrEqualTo: value)
              .where('name', isLessThan: value + 'Z')
              .limit(20)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data.docs.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 8),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Container(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: snapshot.data.docs[index].get('image') !=
                                            null &&
                                        snapshot.data.docs[index]
                                            .get('image')
                                            .isNotEmpty
                                    ? CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        imageUrl: snapshot.data.docs[index]
                                            .get('image'),
                                        width: 80,
                                        height: 50,
                                        fit: BoxFit.contain,
                                      )
                                    : Icon(Icons.image_not_supported_outlined),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  flex: 8,
                                  child: Text(
                                    '${snapshot.data.docs[index].get('name')}'
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        '${snapshot.data.docs[index].get('name')}'
                                            .substring(1)
                                            .toLowerCase(),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  )),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ProductDetails(
                                  snapshot: snapshot.data.docs[index])));
                    },
                  );
                },
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text('no such item found'),
                  ],
                ),
              );
            }
          }),
    );
  }
}
