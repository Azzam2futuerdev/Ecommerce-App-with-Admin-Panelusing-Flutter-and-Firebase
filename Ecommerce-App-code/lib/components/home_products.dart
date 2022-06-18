//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/fliter_products.dart';
import 'package:ecom/product_details.dart';
import 'package:ecom/services/auth_provider.dart';
import 'package:ecom/services/data_provider.dart';

class HomeProducts extends StatelessWidget {
  final DocumentSnapshot snapshot;
  const HomeProducts({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: dataProvider.products(snapshot.data['tag']),
        builder: (context, snap) {
          if (snap.hasData) {
            return snap.data.documents.length > 0
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 2,
                          child: GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data['image'],
                              fit: BoxFit.fill,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FilterProduct(snapshot: snapshot)));
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        AspectRatio(
                          aspectRatio: 1 / 1.05,
                          child: ListView.builder(
                            itemExtent: 210,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snap.data.documents.length + 1,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return index == 0
                                  ? Card(
                                      elevation: 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 150,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.white10
                                                    .withOpacity(0.95)),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data['icon'],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data['tag']}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    )
                                  : HomeProductList(
                                      snapshot: snap.data.documents[index - 1],
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Container();
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

class HomeProductList extends StatelessWidget {
  final DocumentSnapshot snapshot;
  const HomeProductList({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white10.withOpacity(0.95)),
              child: CachedNetworkImage(
                imageUrl: snapshot.data['image'],
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              title: Text(
                '${snapshot.data['name']}',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('Price for ${snapshot.data['quantity']}',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.normal),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.all(6),
                child: Text(
                  '${snapshot.data['quantity']}',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '₹${snapshot.data['selling']}',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      '₹${snapshot.data['mrp']}',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.withOpacity(0.2)),
                padding: EdgeInsets.all(2),
                child: Text(
                  'You save ₹${snapshot.data['mrp'] - snapshot.data['selling']}',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            ),
            Container(
              width: 120,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: dataProvider.cartCheck(snapshot.documentID),
                  builder: (context, snapshotData) {
                    if (snapshotData.hasData) {
                      return snapshotData.data.data != null
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.remove_circle,
                                        color: Colors.redAccent, size: 35),
                                    onPressed: () async {
                                      CollectionReference reference = Firestore
                                          .instance
                                          .collection('Users')
                                          .document(UserProvider.user.uid)
                                          .collection('Cart');
                                      try {
                                        if (snapshotData.data['count'] > 1) {
                                          reference
                                              .document(snapshot.documentID)
                                              .setData({
                                            'count':
                                                snapshotData.data['count'] - 1,
                                            'total':
                                                ((snapshotData.data['count'] -
                                                        1) *
                                                    snapshotData.data['price']),
                                          }, merge: true);
                                        } else {
                                          await reference
                                              .document(snapshot.documentID)
                                              .delete();
                                        }
                                      } catch (e) {}
                                    },
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      snapshotData.data['count'].toString() ??
                                          '',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16),
                                      textAlign: TextAlign.center,
                                    )),
                                Expanded(
                                  flex: 4,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.add_circle_outlined,
                                        color: Colors.redAccent, size: 35),
                                    onPressed: () async {
                                      CollectionReference reference = Firestore
                                          .instance
                                          .collection('Users')
                                          .document(UserProvider.user.uid)
                                          .collection('Cart');
                                      try {
                                        if (snapshotData.data['count'] < 5) {
                                          reference
                                              .document(snapshot.documentID)
                                              .setData({
                                            'count':
                                                snapshotData.data['count'] + 1,
                                            'total':
                                                ((snapshotData.data['count'] +
                                                        1) *
                                                    snapshotData.data['price']),
                                          }, merge: true);
                                        }
                                      } catch (e) {
                                        print(snapshotData.data['price']);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                          : RaisedButton(
                              child: Text('Add',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 16)),
                              color: Colors.redAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              onPressed: () async {
                                CollectionReference reference = Firestore
                                    .instance
                                    .collection('Users')
                                    .document(UserProvider.user.uid)
                                    .collection('Cart');
                                try {
                                  await reference
                                      .document(snapshot.documentID)
                                      .setData({
                                    "image": snapshot.data['image'],
                                    'name': snapshot.data['name'],
                                    'mrp': snapshot.data['mrp'],
                                    'price': snapshot.data['selling'],
                                    'quantity': snapshot.data['quantity'],
                                    'count': 1,
                                    'total': snapshot.data['selling'],
                                    'product': snapshot.documentID
                                  }, merge: true);
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                            );
                    }
                    return RaisedButton(
                      child: Text('Add',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 16)),
                      color: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        print(snapshot.data);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ProductDetails(snapshot: snapshot)));
      },
    );
  }
}
