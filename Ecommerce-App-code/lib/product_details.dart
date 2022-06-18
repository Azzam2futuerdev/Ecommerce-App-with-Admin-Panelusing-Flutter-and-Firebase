//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/cart.dart';
import 'package:ecom/services/auth_provider.dart';
import 'package:ecom/services/data_provider.dart';

class ProductDetails extends StatefulWidget {
  final DocumentSnapshot snapshot;
  const ProductDetails({Key key, this.snapshot}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Future<void> _createDynamicLink(bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://ecom.page.link',
      link: Uri.parse(
          'https://atuskart.page.link/${widget.snapshot.data['name']}'),
      androidParameters: AndroidParameters(
        packageName: "com.diatus.ecom",
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: widget.snapshot.data['name'],
        imageUrl: Uri.parse(widget.snapshot.data['image']),
        description: 'Check out this amazing product',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    await FlutterShare.share(
      title: 'Checkout this product',
      text:
          '${widget.snapshot.data['name']}(Price for ${widget.snapshot.data['quantity']},Rs.${widget.snapshot.data['selling']}) and save upto ${widget.snapshot.data['mrp'] - widget.snapshot.data['selling']} OFF& get free home delivery',
      linkUrl: url.toString(),
      chooserTitle: 'Share to apps',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _createDynamicLink(true);
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
        children: [
          SizedBox(height: 30),
          CachedNetworkImage(
              imageUrl: widget.snapshot.data['image'],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.7),
          SizedBox(height: 20),
          ListTile(
            title: Text(
              '${widget.snapshot.data['name']}',
              style: GoogleFonts.poppins(
                  fontSize: 25, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Price for ${widget.snapshot.data['quantity']}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        alignment: Alignment.center,
                        child: Text(
                            widget.snapshot.data['category']
                                    .map((e) => e)
                                    .first ??
                                '',
                            style: GoogleFonts.poppins(color: Colors.blue)),
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 0, top: 8, bottom: 8),
                      child: widget.snapshot.data['tags'] != null &&
                              widget.snapshot.data['tags'].isNotEmpty
                          ? Container(
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.center,
                              child: Text(
                                  widget.snapshot.data['tags']
                                          .map((e) => e)
                                          .first ??
                                      '',
                                  style:
                                      GoogleFonts.poppins(color: Colors.amber)),
                              decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4)),
                            )
                          : Container(),
                    )),
                Expanded(flex: 4, child: Container()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text(
                          'Rs.₹${widget.snapshot.data['selling']}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          'M.R.P ₹${widget.snapshot.data['mrp']}',
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green.withOpacity(0.3)),
                          child: Text(
                            'You Save ₹${widget.snapshot.data['mrp'] - widget.snapshot.data['selling']}',
                            style: GoogleFonts.poppins(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Text('(including all taxes)', style: GoogleFonts.poppins())
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: StreamBuilder<DocumentSnapshot>(
          stream: dataProvider.cartCheck(widget.snapshot.documentID),
          builder: (context, snapshotData) {
            if (snapshotData.hasData) {
              return snapshotData.data.data != null
                  ? Container(
                      height: 60,
                      child: RaisedButton(
                        child: Text('Go to cart',
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 16)),
                        color: Colors.green,
                        elevation: 0,
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Cart()));
                        },
                      ),
                    )
                  : Container(
                      height: 60,
                      child: RaisedButton(
                        child: Text('Add to cart',
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 16)),
                        color: Colors.redAccent,
                        elevation: 0,
                        onPressed: () async {
                          CollectionReference reference = Firestore.instance
                              .collection('Users')
                              .document(UserProvider.user.uid)
                              .collection('Cart');
                          try {
                            await reference
                                .document(widget.snapshot.documentID)
                                .setData({
                              "image": widget.snapshot.data['image'],
                              'name': widget.snapshot.data['name'],
                              'mrp': widget.snapshot.data['mrp'],
                              'wholesale': widget.snapshot.data['wholesale'],
                              'price': widget.snapshot.data['selling'],
                              'quantity': widget.snapshot.data['quantity'],
                              'count': 1,
                              'total': widget.snapshot.data['selling'],
                              'seller': widget.snapshot.data['seller'],
                              'sellerTotal': widget.snapshot.data['wholesale'],
                              'product': widget.snapshot.documentID
                            }, merge: true);
                          } catch (e) {}
                        },
                      ),
                    );
            }
            return Container(
              height: 60,
              child: RaisedButton(
                child: Text('Add to cart',
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
                color: Colors.redAccent,
                elevation: 0,
                onPressed: () {},
              ),
            );
          }),
    );
  }
}
