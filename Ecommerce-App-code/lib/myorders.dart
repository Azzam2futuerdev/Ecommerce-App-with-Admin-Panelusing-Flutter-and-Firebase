//@dart=2.9
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ecom/services/data_provider.dart';

import 'Orderdetails.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  DateFormat format = DateFormat.yMMMMd('en_US');
  DateFormat time = DateFormat.jm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10.withOpacity(0.95),
      appBar: AppBar(
        backgroundColor: Color(0xff6fb840),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          "My Orders",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: dataProvider.orders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.documents.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                              elevation: 0,
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data
                                                  .documents[index]['image'],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 7,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text.rich(
                                                  TextSpan(text: '', children: [
                                                TextSpan(
                                                    text: snapshot
                                                        .data
                                                        .documents[index]
                                                            ['booking']
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ])),
                                              subtitle: Text.rich(TextSpan(
                                                  text:
                                                      '${format.format(DateTime.fromMicrosecondsSinceEpoch(snapshot.data.documents[index]['booking']))}   ',
                                                  style: GoogleFonts.poppins(),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${time.format(DateTime.fromMicrosecondsSinceEpoch(snapshot.data.documents[index]['booking']))}',
                                                    )
                                                  ])),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8,
                                                    ),
                                                    child: Text(
                                                      '₹${snapshot.data.documents[index]['total']}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 4,
                                                    ),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                    0xff32CC34)
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        child: Text(
                                                          '${snapshot.data.documents[index]['status']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xff32CC34),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ))
                                  ])),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        OrderDetails(
                                            snapshot.data.documents[index])));
                          },
                        );
                      },
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/atus-kart.appspot.com/o/static%2Fbasket.png?alt=media&token=4ca7a331-90d3-4ce0-8113-0226e577085e',
                              width: 120,
                              height: 120),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 12),
                            child: Text('No items in your cart!',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60, right: 60),
                            child: Text(
                              "We are looking to provide our services for you",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
