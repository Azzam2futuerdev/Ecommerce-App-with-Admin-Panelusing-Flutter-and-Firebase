//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vdsadmin/models/data_provider.dart';

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
          'https://atuskart.page.link/${widget.snapshot.get('name')}'),
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
        title: widget.snapshot.get('name'),
        imageUrl: Uri.parse(widget.snapshot.get('image')),
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
          '${widget.snapshot.get('name')}(Price for ${widget.snapshot.get('quantity')},Rs.${widget.snapshot.get('selling')}) and save upto ${widget.snapshot.get('mrp') - widget.snapshot.get('selling')} OFF& get free home delivery',
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
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: widget.snapshot.get('image'),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.7),
          SizedBox(height: 20),
          ListTile(
            title: Text(
              '${widget.snapshot.get('name')}',
              style: GoogleFonts.poppins(
                  fontSize: 25, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Price for ${widget.snapshot.get('quantity')}',
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
                            widget.snapshot
                                    .get('category')
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
                      child: widget.snapshot.get('tags') != null &&
                              widget.snapshot.get('tags').isNotEmpty
                          ? Container(
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.center,
                              child: Text(
                                  widget.snapshot
                                          .get('tags')
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
                          'Rs.₹${widget.snapshot.get('selling')}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          'M.R.P ₹${widget.snapshot.get('mrp')}',
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
                            'You Save ₹${widget.snapshot.get('mrp') - widget.snapshot.get('selling')}',
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
    );
  }
}
