//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/services/auth_provider.dart';
import 'package:ecom/services/data.dart';
import 'package:ecom/services/data_provider.dart';
import 'adress.dart';
import 'components/cart_card.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartData> cart = [];
  String discount;
  double saving = 0;
  double mrp = 0;
  double total = 0;
  List<dynamic> images = [];

  Future _get() async {
    cart = [];
    CollectionReference reference = Firestore.instance
        .collection('Users')
        .document(UserProvider.user.uid)
        .collection('Cart');
    try {
      QuerySnapshot snapshot = await reference.getDocuments();
      setState(() {
        total = 0;
        mrp = 0;
      });
      snapshot.documents.map((e) {
        setState(() {
          cart.add(CartData(
              e.data['image'],
              e.data['name'],
              e.data['mrp'].toString(),
              e.data['price'].toString(),
              e.data['quantity'],
              e.data['count'],
              e.data['total'].toString(),
              e.documentID));
          total = double.parse(e.data['total'].toString()) + total;
          mrp = double.parse(e.data['mrp'].toString()) * e.data['count'] + mrp;
        });
      }).toList();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    _get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10.withOpacity(0.95),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff6fb840),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop()),
        // automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          'My Cart',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          cart != null && cart.isNotEmpty
              ? Card(
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTile(
                          title: "M.R.P",
                          tail: "₹$mrp",
                          titlestyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, color: Colors.grey),
                          tailstyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, color: Colors.grey)),
                      CustomTile(
                          title: 'Products Discount',
                          tail: '-₹${mrp - total} OFF',
                          titlestyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, color: Colors.grey),
                          tailstyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.green)),
                      CustomTile(
                          title: 'Your Saving',
                          tail: '₹${mrp - total}',
                          titlestyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, color: Colors.grey),
                          tailstyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.green)),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Sub Total:',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('(including all taxes)'),
                        trailing: Text('₹$total',
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
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
                ),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
              stream: dataProvider.cart(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.hasData) {
                      _get();
                      return CartCard(snapshot: snapshot.data.documents[index]);
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
      bottomNavigationBar: cart != null && cart.isNotEmpty
          ? ListTile(
              tileColor: Colors.green,
              title: Text(
                '₹$total',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text('including all taxes',
                  style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9))),
              trailing: Container(
                height: 45,
                width: MediaQuery.of(context).size.width * 0.3,
                child: RaisedButton(
                  elevation: 0,
                  onPressed: () async {
                    CollectionReference reference = Firestore.instance
                        .collection('Users')
                        .document(UserProvider.user.uid)
                        .collection('Cart');
                    try {
                      QuerySnapshot snapshot = await reference.getDocuments();
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Address(
                                  'grocery',
                                  mrp,
                                  mrp - total,
                                  total,
                                  UserProvider.pincode,
                                  snapshot)));
                    } catch (e) {}
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                    "Checkout",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  color: Colors.white,
                ),
              ),
            )
          : null,
      // bottomNavigationBar: BNavigation(),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final String tail;
  final TextStyle titlestyle;
  final TextStyle tailstyle;
  CustomTile(
      {@required this.title,
      @required this.tail,
      @required this.titlestyle,
      @required this.tailstyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Row(
        children: [
          Expanded(
            child: Align(
              child: Text(
                '$title',
                style: titlestyle,
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(
            child: Align(
              child: Text(
                '$tail',
                style: tailstyle,
              ),
              alignment: Alignment.centerRight,
            ),
          )
        ],
      ),
    );
  }
}
