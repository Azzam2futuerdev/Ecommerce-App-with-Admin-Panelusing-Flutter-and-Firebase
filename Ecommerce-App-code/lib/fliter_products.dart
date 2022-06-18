//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/product_details.dart';
import 'package:ecom/search.dart';
import 'package:ecom/services/data_provider.dart';
import 'cart.dart';
import 'components/product_view.dart';

class FilterProduct extends StatefulWidget {
  final DocumentSnapshot snapshot;

  FilterProduct({this.snapshot});
  @override
  _FilterProductState createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  bool loading = false;
  String filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10.withOpacity(0.95),
      appBar: AppBar(
        backgroundColor: Color(0xff6fb840),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${widget.snapshot.data['name']}',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => Search(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 10),
                ),
              );
            },
          ),
          StreamBuilder<QuerySnapshot>(
              stream: dataProvider.cart(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.documents.length > 0
                      ? GestureDetector(
                          child: Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.only(left: 4),
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 16,
                                    child: Icon(Icons.shopping_cart_outlined,
                                        size: 25, color: Colors.white)),
                                Positioned(
                                    top: 8,
                                    right: 0,
                                    left: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 6,
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
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Cart()));
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.shopping_cart_outlined,
                              size: 25, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Cart()));
                          });
                }
                return IconButton(
                    icon: Icon(Icons.shopping_cart_outlined,
                        size: 25, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Cart()));
                    });
              }),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 8),
          widget.snapshot.data['tags'] != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.snapshot.data['tags'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 0,
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: filter ==
                                            widget.snapshot.data['tags'][index]
                                                ['name']
                                        ? Colors.green
                                        : Colors.white,
                                    width: 2)),
                            child: Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.snapshot.data['tags']
                                          [index]['image'],
                                      fit: BoxFit.contain,
                                      width: 60,
                                      height: 60,
                                    )),
                                SizedBox(width: 8),
                                Container(
                                    width: 90,
                                    child: Text(
                                        '${widget.snapshot.data['tags'][index]['name']}',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600),
                                        maxLines: 2,
                                        overflow: TextOverflow.clip)),
                                SizedBox(width: 4),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              filter =
                                  widget.snapshot.data['tags'][index]['name'];
                            });
                          },
                        ),
                      );
                    },
                  ),
                )
              : Container(),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
              stream: dataProvider.products(widget.snapshot.data['tag']),
              builder: (context, snapshot) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.hasData) {
                      return ProductView(
                        snapshot: snapshot.data.documents[index],
                        onClick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductDetails(
                                          snapshot:
                                              snapshot.data.documents[index])));
                        },
                      );
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'Loading....',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 80, right: 80),
                            child: Text(
                              "We are looking to match best product for you",
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              })
        ],
      ),
    );
  }
}
