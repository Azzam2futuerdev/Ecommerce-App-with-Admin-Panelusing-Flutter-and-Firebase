//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/services/auth_provider.dart';
import 'package:ecom/successful.dart';
import 'Cart.dart';

class CheckOut extends StatefulWidget {
  final String type;
  final String name;
  final String address;
  final double delivery;
  final double sub;
  final double saving;
  final double total;
  final QuerySnapshot snapshot;

  CheckOut(this.type, this.name, this.address, this.delivery, this.sub,
      this.saving, this.total, this.snapshot);
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  List<dynamic> images = [];
  String image;

  List<Map<dynamic, dynamic>> track = [
    {'message': 'Order Placed', 'time': DateTime.now().millisecondsSinceEpoch}
  ];
  bool wallet = false;
  void initState() {
    // TODO: implement initState
    image = widget.snapshot.documents.length == 1
        ? widget.snapshot.documents.map((e) => e.data['image']).first
        : 'https://firebasestorage.googleapis.com/v0/b/atus-kart.appspot.com/o/static%2Fweb%20png%20only-0.png?alt=media&token=b914188f-effc-46a2-bbe2-79a025b1175a';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10.withOpacity(0.95),
      appBar: AppBar(
        backgroundColor: Color(0xff6fb840),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _payment(),
    );
  }

  _payment() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: Text(
            'Order Details',
            style: GoogleFonts.poppins(fontSize: 21),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTile(
                    title: 'Items Total',
                    tail: '₹${widget.sub}',
                    titlestyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 16),
                    tailstyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontSize: 16)),
                CustomTile(
                    title: 'Delivery Charge',
                    tail: '₹${widget.delivery}',
                    titlestyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 16),
                    tailstyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontSize: 16)),
                CustomTile(
                    title: 'Sub Total',
                    tail: '₹${widget.sub + widget.delivery}',
                    titlestyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 16),
                    tailstyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontSize: 16)),
                CustomTile(
                    title: 'Total Saving',
                    tail: '- ₹${widget.saving}',
                    titlestyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 16),
                    tailstyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff6fb840),
                        fontSize: 16)),
                CustomTile(
                    title: 'Discount',
                    tail:
                        '${((widget.saving / widget.sub) * 100).floor()}% OFF',
                    titlestyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 16),
                    tailstyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff6fb840),
                        fontSize: 16)),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Total:',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'including all taxes',
                            style: GoogleFonts.poppins(
                                color: Color.fromRGBO(112, 112, 112, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        "₹${widget.total + widget.delivery}",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: Text(
            'Shipping Address',
            style: GoogleFonts.poppins(fontSize: 21),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: ListTile(
                title: Text('${widget.name}',
                    style: GoogleFonts.poppins(fontSize: 18)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('${widget.address}',
                      style: GoogleFonts.poppins(fontSize: 15)),
                ),
                trailing: Icon(
                  Icons.local_shipping_outlined,
                  size: 40,
                  color: Color(0xff6fb840),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            'Payment Method',
            style: GoogleFonts.poppins(fontSize: 21),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 0,
            child: Container(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.local_shipping_outlined,
                      size: 40,
                      color: Color(0xff6fb840),
                    ),
                    title: Text(
                      'Cash On delivery',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text('Avail instant 2% OFF on COD '),
                    tileColor: Colors.white,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            height: 50.0,
            margin: EdgeInsets.only(left: 16, right: 16),
            child: RaisedButton(
              elevation: 1,
              onPressed: () {
                _update();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.green],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(80.0)),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Continue to place",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Future _update() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightGreenAccent,
            ),
          );
        },
        barrierDismissible: false);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentReference reference =
        Firestore.instance.collection("Orders").document();
    try {
      reference.setData({
        'id': reference.documentID,
        'image': image,
        'total': widget.total + widget.delivery,
        'delivery': widget.delivery,
        'saving': widget.saving,
        'sub': widget.sub,
        'booking': DateTime.now().microsecondsSinceEpoch,
        'name': widget.name,
        'address': widget.address,
        'phone': user.phoneNumber,
        'user': user.uid,
        'pincode': UserProvider.pincode,
        'status': 'Order Placed',
        'track': track
      }, merge: true);
      _items(reference.documentID);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future _items(String id) async {
    CollectionReference reference = Firestore.instance.collection('Items');
    try {
      widget.snapshot.documents.map((e) {
        reference.document().setData({
          'type': widget.type,
          'orderID': id,
          'productID': e.documentID,
          'seller': e['seller'],
          'total': e['total'],
          'price': e['price'],
          'sellerTotal': e['sellerTotal'],
          'wholesale': e['wholesale'],
          'image': e['image'],
          'quantity': e['quantity'],
          'name': e['name'],
          'pieces': e['count']
        }, merge: true);
      }).toList();
      _delete(id);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future _delete(String id) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('Users')
        .document(user.uid)
        .collection('Cart')
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => OrderSuccessful(id)));
    }).catchError((onError) {
      Navigator.pop(context);
    });
  }
}
