import 'dart:typed_data';
import 'dart:ui';
import 'dart:io' as android;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vdsadmin/invoice/pdf_api.dart';
import 'package:vdsadmin/invoice/pdf_invoice_api.dart';
import 'package:vdsadmin/invoice/pdf_invoice_syncfusion.dart';
import 'package:vdsadmin/models/customer.dart';
import 'package:vdsadmin/models/data_provider.dart';
import 'package:vdsadmin/models/firebase.service.dart';
import 'package:vdsadmin/models/invoice.dart';
import 'package:vdsadmin/models/suppiler.dart';
import 'package:vdsadmin/whatsappApi/wa.dart';
import 'package:vdsadmin/widgets/raised_gradient_button.dart';

import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class Bill extends StatefulWidget {
  const Bill({Key? key}) : super(key: key);

  @override
  _BillState createState() => _BillState();
}

class _BillState extends State<Bill> {
  String? Dataseturl;
  var url;
  late StateSetter sete;
  var category1;
  late String tags2;
  late String category2;
  List<String> images = [];
  List<String> productnames = [];
  List<String> barcodes = [];
  List<String> desc = [];
  List<String> cat = [];
  List<dynamic> prices = [];
  List<dynamic> mrp = [];
  List<int> count = [];
  List<InvoiceItem> saman = [
    InvoiceItem(
      description: 'Thanks for shopping',
      quantity: 0,
      MRP: 0.00,
      OurPrice: 0.00,
    ),
  ];
  final List<Map<String, dynamic>> snapshots = [];
  TextEditingController contact = TextEditingController();

  TextEditingController newProductName = TextEditingController();
  TextEditingController newMRP = TextEditingController();
  TextEditingController newSP = TextEditingController();
  String? _barcode;
  dynamic mrptotal = 0;
  dynamic total = 0;
  late bool visible;
  void clearText() {
    contact.clear();
  }

  String? scanBarcode;
  ScrollController controller = ScrollController();
  Map? data;
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      scanBarcode = barcodeScanRes;
      Fetcher(barcodeScanRes);
    });
  }

  Widget _buildProductItem(BuildContext context, int index) {
    form(String title, String hint, TextEditingController controller, Icon ic) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white)),
              child: TextFormField(
                controller: controller,
                showCursor: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "$hint",
                  prefixIcon: ic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(children: <Widget>[
          images[index] != null
              ? Image.network(
                  images[index],
                  height: 80,
                  width: 80,
                )
              : const Icon(Icons.photo_size_select_actual_outlined),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  productnames[index],
                  style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text('₹${prices[index]}',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text('₹${mrp[index]}',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.remove_circle,
                          color: Colors.redAccent, size: 35),
                      onPressed: () async {
                        try {
                          if (count[index] >= 1) {
                            count[index] = count[index] - 1;

                            mrptotal = mrptotal - mrp[index];
                            total = total - prices[index];
                            setState(() {});
                          }
                          if (count[index] == 0) {
                            count.removeAt(index);
                            images.removeAt(index);
                            productnames.removeAt(index);
                            barcodes.removeAt(index);
                            prices.removeAt(index);
                            mrp.removeAt(index);
                            desc.removeAt(index);
                            cat.removeAt(index);
                          }
                        } catch (e) {}
                      },
                    ),
                    Text(
                      '${count[index]}',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.add_circle_outlined,
                          color: Colors.redAccent, size: 35),
                      onPressed: () async {
                        try {
                          if (count[index] < 5) {
                            count[index] = count[index] + 1;
                            mrptotal = mrptotal + mrp[index];
                            total = total + prices[index];
                            setState(() {});
                          }
                        } catch (e) {}
                      },
                    ),
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () {
                          // UpdateData();
                          showDialog(
                              context: context,
                              builder: (
                                context,
                              ) {
                                return Dialog(
                                    backgroundColor: Colors.blueGrey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      var sete = setState;

                                      TextEditingController FBProductName =
                                          TextEditingController(
                                              text: productnames[index]);
                                      TextEditingController FBMRP =
                                          TextEditingController(
                                              text: mrp[index].toString());
                                      TextEditingController FBSP =
                                          TextEditingController(
                                              text: prices[index].toString());
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: ListView(
                                            children: [
                                              const SizedBox(height: 8),
                                              const Center(
                                                child: Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Text(
                                                        "Update Details",
                                                        style: TextStyle(
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.white))),
                                              ),
                                              const SizedBox(height: 8),
                                              form(
                                                'Product name',
                                                productnames[index],
                                                FBProductName,
                                                const Icon(
                                                  Icons.description,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              form(
                                                'Enter MRP',
                                                mrp[index].toString(),
                                                FBMRP,
                                                const Icon(
                                                  Icons.description,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              form(
                                                'Enter Selling price',
                                                prices[index].toString(),
                                                FBSP,
                                                const Icon(
                                                  Icons.description,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 30),
                                              MaterialButton(
                                                elevation: 0,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'UPDATE',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  InsertDatainFirebase().upload(
                                                      barcodes[index],
                                                      FBProductName.text,
                                                      desc[index],
                                                      FBMRP.text,
                                                      FBSP.text,
                                                      count[index],
                                                      FBSP.text,
                                                      images[index],
                                                      cat[index]);
                                                  productnames[index] =
                                                      FBProductName.text;
                                                  mrp[index] =
                                                      double.parse(FBMRP.text);
                                                  prices[index] =
                                                      double.parse(FBSP.text);
                                                  setState(() {});
                                                  FBProductName.clear();
                                                  FBMRP.clear();
                                                  FBSP.clear();

                                                  Navigator.of(context).pop();
                                                },
                                                color: Colors.green,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }));
                              });
                        },
                        child: Icon(Icons.edit),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () {
                          mrptotal = mrptotal - (count[index] * mrp[index]);
                          total = total - (count[index] * prices[index]);
                          count.removeAt(index);
                          images.removeAt(index);
                          productnames.removeAt(index);
                          barcodes.removeAt(index);
                          prices.removeAt(index);
                          mrp.removeAt(index);
                          desc.removeAt(index);
                          cat.removeAt(index);
                          setState(() {});
                        },
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late StateSetter sete;
    form(String title, String hint, TextEditingController controller, Icon ic) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white)),
              child: TextField(
                controller: controller,
                showCursor: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "$hint",
                  prefixIcon: ic,
                ),
                onChanged: (text) {
                  // 1236805964134
                  if (text.length >= 12) {
                    FirebaseFirestore.instance
                        .collection("Products")
                        .doc(text)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        print('Document data: ${documentSnapshot.data()}');
                        Map<String, dynamic> data1 =
                            documentSnapshot.data() as Map<String, dynamic>;
                        var index = -1;
                        var present = false;
                        for (var i = 0; i < barcodes.length; i++) {
                          // you may have to check the equality operator
                          if (data1["barcode"] == barcodes[i]) {
                            present = true;
                            index = i;
                            break;
                          }
                        }
                        if (index >= 0) {
                          count[index] = count[index] + 1;
                          saman[index + 1].quantity = saman[index].quantity + 1;
                          mrptotal = mrptotal + mrp[index];
                          total = total + prices[index];
                          setState(() {});
                        } else {
                          setState(() {
                            images.add(data1["image"]);
                            productnames.add(data1["name"]);
                            barcodes.add(data1["barcode"]);
                            prices.add(data1["selling"]);
                            mrp.add(data1["mrp"]);
                            desc.add(data1["description"]);
                            cat.add(data1["category"][0]);
                            count.add(1);
                            snapshots.add(data1);
                            saman.add(
                              InvoiceItem(
                                description: data1["name"],
                                quantity: 1,
                                MRP: data1["mrp"],
                                OurPrice: data1["selling"],
                              ),
                            );
                            mrptotal = mrptotal + data1["mrp"];
                            total = total + data1["selling"];
                            clearText();
                            controller.selection = TextSelection.fromPosition(
                                TextPosition(offset: controller.text.length));
                          });
                        }
                      } else {
                        print('Document does not exist on the database');
                        Fluttertoast.showToast(
                            msg: 'Document does not exist on the database');
                        addNewItemToDatabase(text);
                      }
                    });
                  }
                  print('First text field: $text');
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Billing '),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          MaterialButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: const Text(
                'Add New',
                style: TextStyle(color: Colors.white),
              ),
              color: const Color(0xffCB0338),
              onPressed: () {
                addNewItem();
              }),
          SizedBox(
            width: 10,
          ),
          MaterialButton(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xffCB0338),
            child: const Text(
              'Scan BarCode',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              scanBarcodeNormal();
              setState(() {});
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          barcodes.isNotEmpty
              ? Card(
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTile(
                          title: "M.R.P",
                          tail: "₹${mrptotal}",
                          titlestyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, color: Colors.grey),
                          tailstyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, color: Colors.grey)),
                      CustomTile(
                          title: 'Products Discount',
                          tail: '-₹${mrptotal - total} OFF',
                          titlestyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, color: Colors.grey),
                          tailstyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.green)),
                      CustomTile(
                          title: 'Your Saving',
                          tail: '₹${mrptotal - total}',
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
                        trailing: Text('₹${total}',
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                )
              : Expanded(
                  // height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/atus-kart.appspot.com/o/static%2Fbasket.png?alt=media&token=4ca7a331-90d3-4ce0-8113-0226e577085e',
                          width: 120,
                          height: 120),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8, top: 12),
                        child: Text('No items in your cart!',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 60, right: 60),
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
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemBuilder: _buildProductItem,
            itemCount: images.length,
          ),
          Center(
            // Add visiblity detector to handle barcode
            // values only when widget is visible
            child: VisibilityDetector(
              onVisibilityChanged: (VisibilityInfo info) {
                visible = info.visibleFraction > 0;
              },
              key: Key('visible-detector-key'),
              child: BarcodeKeyboardListener(
                bufferDuration: Duration(milliseconds: 200),
                onBarcodeScanned: (barcode) {
                  if (!visible) return;
                  print(barcode);
                  FirebaseFirestore.instance
                      .collection("Products")
                      .doc(barcode)
                      .get()
                      .then((DocumentSnapshot documentSnapshot) {
                    if (documentSnapshot.exists) {
                      print('Document data: ${documentSnapshot.data()}');
                      Map<String, dynamic> data1 =
                          documentSnapshot.data() as Map<String, dynamic>;

                      var index = -1;
                      var present = false;
                      for (var i = 0; i < barcodes.length; i++) {
                        // you may have to check the equality operator
                        if (data1["barcode"] == barcodes[i]) {
                          present = true;
                          index = i;
                          break;
                        }
                      }
                      if (index >= 0) {
                        count[index] = count[index] + 1;
                        // saman[index].quantity = saman[index].quantity + 1;
                        mrptotal = mrptotal + mrp[index];
                        total = total + prices[index];
                        setState(() {});
                      } else {
                        setState(() {
                          images.add(data1["image"]);
                          productnames.add(data1["name"]);
                          barcodes.add(data1["barcode"]);
                          prices.add(data1["selling"]);
                          mrp.add(data1["mrp"]);
                          desc.add(data1["description"]);
                          cat.add(data1["category"][0]);
                          count.add(1);
                          snapshots.add(data1);
                          saman.add(
                            InvoiceItem(
                              description: data1["name"],
                              quantity: 1,
                              MRP: data1["mrp"],
                              OurPrice: data1["selling"],
                            ),
                          );
                          _barcode = barcode;
                          mrptotal = mrptotal + data1["mrp"];
                          total = total + data1["selling"];
                          // barcode.text = barcode;
                          clearText();
                        });
                      }
                    } else {
                      print('Document does not exist on the database');
                      Fluttertoast.showToast(
                          msg: 'Document does not exist on the database');
                      addNewItemToDatabase(barcode);
                    }
                  });
                },
                // child: SizedBox(
                //   height: 1,
                // ),
                child: Column(
                  children: <Widget>[
                    Text(
                      _barcode == null
                          ? 'Waiting for new BARCODE'
                          : 'BARCODE: $_barcode',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // body: Fetcher(),
      bottomNavigationBar: mrp.isNotEmpty
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
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  children: [
                    MaterialButton(
                      elevation: 0,
                      onPressed: () => Clear(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: const Text(
                        "Clear",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      elevation: 0,
                      onPressed: () => Checkout(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: const Text(
                        "Checkout",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Future<void> Fetcher(String text) async {
    var stream = FirebaseFirestore.instance.collection("Products1");
    QuerySnapshot querySnapshot = await stream.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    var length = querySnapshot.docs.length;
    print(length);
    print(allData);

    print("Now callng individual dataset");
    FirebaseFirestore.instance
        .collection("Products")
        .doc(text)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        Map<String, dynamic> data1 =
            documentSnapshot.data() as Map<String, dynamic>;
        var index = -1;
        var present = false;
        for (var i = 0; i < barcodes.length; i++) {
          // you may have to check the equality operator
          if (data1["barcode"] == barcodes[i]) {
            present = true;
            index = i;
            break;
          }
        }
        if (index >= 0) {
          count[index] = count[index] + 1;
          saman[index + 1].quantity = saman[index + 1].quantity + 1;
          mrptotal = mrptotal + mrp[index];
          total = total + prices[index];
          setState(() {});
        } else {
          setState(() {
            images.add(data1["image"]);
            productnames.add(data1["name"]);
            barcodes.add(data1["barcode"]);
            prices.add(data1["selling"]);
            mrp.add(data1["mrp"]);
            cat.add(data1["category"][0]);
            desc.add(data1["description"]);
            snapshots.add(data1);
            count.add(1);
            saman.add(
              InvoiceItem(
                description: data1["name"],
                quantity: 1,
                MRP: data1["mrp"],
                OurPrice: data1["selling"],
              ),
            );
            mrptotal = mrptotal + data1["mrp"];
            total = total + data1["selling"];
          });
        }
      } else {
        print('Document does not exist on the database');
        Fluttertoast.showToast(msg: 'Document does not exist on the database');
        addNewItemToDatabase(text);
      }
    });
  }

  Widget center(String text) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      alignment: Alignment.center,
      child: Text(
        '$text',
        style: TextStyle(
          fontSize: size.height * 0.025,
          fontWeight: FontWeight.w400,
          color: Colors.black.withOpacity(0.56),
        ),
      ),
    );
  }

  Future<void> addToList(String PName, double m, double sp) async {
    setState(() {
      images.add(
          'https://thumbs.dreamstime.com/b/new-item-sticker-label-editable-vector-illustration-isolated-white-background-new-item-sticker-123424483.jpg');
      productnames.add(PName);
      barcodes.add('110 101 119 32 105 116 101 109 10');
      prices.add(sp);
      mrp.add(m);
      cat.add("category");
      desc.add("description");
      count.add(1);
      saman.add(
        InvoiceItem(
          description: PName,
          quantity: 1,
          MRP: m,
          OurPrice: sp,
        ),
      );

      total = total + sp;
      mrptotal = mrptotal + m;
    });
  }

  Future<void> addToDatabase(
    String barcode,
    String PName,
    double m,
    String mrp1,
    double sp,
    String selling,
  ) async {
    setState(() {
      images.add(
          'https://thumbs.dreamstime.com/b/new-item-sticker-label-editable-vector-illustration-isolated-white-background-new-item-sticker-123424483.jpg');
      productnames.add(PName);
      barcodes.add(barcode);
      prices.add(sp);
      mrp.add(m);
      cat.add("category");
      desc.add("description");
      count.add(1);
      saman.add(
        InvoiceItem(
          description: PName,
          quantity: 1,
          MRP: m,
          OurPrice: sp,
        ),
      );

      total = total + sp;
      mrptotal = mrptotal + m;
      Dataseturl == null
          ? InsertDatainFirebase().upload(
              barcode,
              PName,
              PName,
              mrp1,
              selling,
              'quantity',
              selling,
              'https://thumbs.dreamstime.com/b/new-item-sticker-label-editable-vector-illustration-isolated-white-background-new-item-sticker-123424483.jpg',
              category1)
          : InsertDatainFirebase().upload(barcode, PName, PName, mrp1, selling,
              'quantity', selling, Dataseturl, category1);
    });
  }

  void Clear() {
    images.clear();
    productnames.clear();
    barcodes.clear();
    prices.clear();
    mrp.clear();
    cat.clear();
    desc.clear();
    snapshots.clear();
    count.clear();
    saman.clear();
    mrptotal = 0;
    total = 0;
    setState(() {});
  }

  void Checkout() {
    form(String title, String hint, TextEditingController controller, Icon ic) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white)),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                showCursor: true,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "$hint",
                  prefixIcon: ic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                var sete = setState;
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView(
                      children: [
                        const Center(
                          child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("Checkout",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white))),
                        ),
                        ListTile(
                          tileColor: Colors.green,
                          title: Text(
                            'Total',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('including all taxes',
                              style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.9))),
                          trailing: Text(
                            '₹$total',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        form(
                          'Enter Customer Number',
                          'Customer Number',
                          contact,
                          const Icon(
                            Icons.send_to_mobile_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        MaterialButton(
                          elevation: 0,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Checkout',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final invoice1 = CreateInvoice();
                            final pdfFile =
                                await PdfInvoiceApi.generate(invoice1);
                            PdfInvoiceSyncFusion.generateInvoice();
                            Navigator.pop(context);
                            DocumentReference reference = FirebaseFirestore
                                .instance
                                .collection("OfflineOrders")
                                .doc();
                            try {
                              reference.set({
                                'id': reference.id,
                                'image':
                                    'https://firebasestorage.googleapis.com/v0/b/atus-kart.appspot.com/o/static%2Fweb%20png%20only-0.png?alt=media&token=b914188f-effc-46a2-bbe2-79a025b1175a',
                                'total': total,
                                'delivery': 'order completed',
                                'saving': '${mrptotal - total}',
                                'booking': DateTime.now().day +
                                    DateTime.now().month +
                                    DateTime.now().year +
                                    DateTime.now().hour +
                                    DateTime.now().minute,
                                'name': 'Customer',
                                'address': 'From Shop',
                                'phone': contact.text,
                                'status': 'Order Complete',
                              });
                              _items(reference.id);
                            } catch (e) {
                              Navigator.pop(context);
                            }
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Whatsap(
                                  number: contact.text,
                                  pth: pdfFile.path,
                                ),
                              ),
                            );
                            setState(() {});
                            // PdfApi.openFile(pdfFile);
                          },
                          color: Colors.green,
                        )
                      ],
                    ),
                  ),
                );
              }));
        });
  }

  Future _items(String id) async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('BillItems');
    try {
      reference
          .doc(
              '${DateTime.now().day + DateTime.now().month + DateTime.now().year + DateTime.now().hour + DateTime.now().minute}')
          .set(
        {
          'orderID':
              '${DateTime.now().day + DateTime.now().month + DateTime.now().year + DateTime.now().hour + DateTime.now().minute}',
          'images': images,
          'product': productnames,
          'barcodes': barcodes,
          'desc': desc,
          'cat': cat,
          'prices': prices,
          'mrp': mrp,
          'count': count,
        },
      );
    } catch (e) {
      Navigator.pop(context);
    }
  }

  void addNewItem() {
    form(String title, String hint, TextEditingController controller, Icon ic) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white)),
              child: TextField(
                controller: controller,
                showCursor: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "$hint",
                  prefixIcon: ic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                var sete = setState;
                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 8),
                        const Center(
                          child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("Add New Item",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white))),
                        ),
                        const SizedBox(height: 8),
                        form(
                          'Enter Product name',
                          'Product name',
                          newProductName,
                          const Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        form(
                          'Enter MRP',
                          'MRP',
                          newMRP,
                          const Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                        ),
                        form(
                          'Enter Selling price',
                          'Selling Price',
                          newSP,
                          const Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        MaterialButton(
                          elevation: 0,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            addToList(
                                newProductName.text,
                                double.parse(newMRP.text),
                                double.parse(newSP.text));
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          color: Colors.green,
                        )
                      ],
                    ),
                  ),
                );
              }));
        });
  }

  void addNewItemToDatabase(String barcode) {
    form(String title, String hint, TextEditingController controller, Icon ic) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white)),
              child: TextField(
                controller: controller,
                showCursor: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "$hint",
                  prefixIcon: ic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                var sete = setState;
                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 8),
                        const Center(
                          child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("Add New Item to Database",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white))),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Barcode',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.backup_table_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        barcode,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        form(
                          'Enter Product name',
                          'Product name',
                          newProductName,
                          const Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        form(
                          'Enter MRP',
                          'MRP',
                          newMRP,
                          const Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                        ),
                        form(
                          'Enter Selling price',
                          'Selling Price',
                          newSP,
                          const Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Select Category',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(8)),
                              border: Border.all(color: Colors.white)),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: dataProvider.category(),
                              builder: (context, snapshot) {
                                return DropdownButton(
                                  value: category1,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  ),
                                  iconSize: 24,
                                  elevation: 16,
                                  isExpanded: true,
                                  underline: Container(),
                                  hint: const Text(
                                    'Category',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (v) {
                                    setState(() {
                                      category1 = v;
                                    });
                                  },
                                  items: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return DropdownMenuItem(
                                      value: data['tag'],
                                      child: Text(data['tag']),
                                    );
                                  }).toList(),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Dataseturl == null
                                  ? const Icon(Icons.image)
                                  : Image.network(
                                      Dataseturl!,
                                      height: 200.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedGradientButton(
                                  child: const Text(
                                    'Upload Image',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  gradient: const LinearGradient(
                                    colors: <Color>[
                                      Color(0xffCB0338),
                                      Color(0xffFF5001)
                                    ],
                                  ),
                                  // onPressed: () => startFilePicker(),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialog(context),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        MaterialButton(
                          elevation: 0,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'ADD TO DATABASE',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            addToDatabase(
                              barcode,
                              newProductName.text,
                              double.parse(newMRP.text),
                              newMRP.text,
                              double.parse(newSP.text),
                              newSP.text,
                            );
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          color: Colors.green,
                        )
                      ],
                    ),
                  ),
                );
              }));
        });
  }

  void UpdateData() {
    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                sete = setState;
                return Text('hello World');
              }));
        });
  }

  Invoice CreateInvoice() {
    final date = DateTime.now();
    final dueDate = date.add(const Duration(days: 7));

    final invoice = Invoice(
      supplier: const Supplier(
        name: 'Vishal Departmental Store',
        address: 'A-126, Murlipura Scheme, Murlipura,Jaipur, Rajasthan',
        paymentInfo: ' VDS',
      ),
      customer: Customer(
        name: 'Customer',
        contact: contact.text,
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'Thanks for shopping at Vishal Departmental Store',
        number:
            '${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}-${DateTime.now().hour}${DateTime.now().minute}',
      ),
      items: saman,
    );

    return invoice;
  }

  Future<void> ImagePickerFromGalleryWeb() async {
    final picker = ImagePicker();
    var fb = FirebaseStorage.instance;
    XFile? dfile;
    final filePath = '${DateTime.now()}.png';
    var file;
    FilePickerResult? result;
    try {
      result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png']);
    } catch (e) {
      print(e);
    }
    if (result != null) {
      try {
        Uint8List? uploadFile = result.files.single.bytes;
        String filename = result.files.single.name;
        var upl = fb.ref().child("shops/$filePath").putData(uploadFile!);
        String downloadurl = await (await upl).ref.getDownloadURL();
        print(downloadurl);
        setState(() {
          url = downloadurl;
          Dataseturl = downloadurl;
        });

        Fluttertoast.showToast(msg: 'Image Uploade Sucessfully');
      } catch (e) {
        print(e);
      }
    } else {
      // TODO: show "file not selected" snack bar
    }
  }

  Future<void> ImagePickerFromGallery() async {
    final picker = ImagePicker();
    var fb = FirebaseStorage.instance;
    XFile? dfile;
    final filePath = '${DateTime.now()}.png';
    var file;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      dfile = (await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 70));
      if (dfile != null) {
        file = android.File(dfile.path);
        var upl = fb.ref().child("shops/$filePath").putFile(file).then((value) {
          return value;
        });
        String downloadurl = await (await upl).ref.getDownloadURL();
        setState(() {
          url = downloadurl;
          Dataseturl = downloadurl;
        });

        Fluttertoast.showToast(msg: 'Image Uploade Sucessfully');
      } else {
        print('No image Selected');
      }
    } else {
      print('Permission not Provided');
    }
  }

  Future<void> ImagePickerFromCamera() async {
    final picker = ImagePicker();
    var fb = FirebaseStorage.instance;
    XFile? dfile;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      dfile = (await picker.pickImage(
          source: ImageSource.camera, imageQuality: 70));
      if (dfile != null) {
        final filePath = '${DateTime.now()}.png';
        var file = android.File(dfile.path);

        var upl = fb.ref().child("shops/$filePath").putFile(file).then((value) {
          return value;
        });
        String downloadurl = await (await upl).ref.getDownloadURL();
        url = file;
        Dataseturl = downloadurl;
        Fluttertoast.showToast(msg: 'Image Uploade Sucessfully');
        setState(() {});
      } else {
        print('No image Selected');
      }
    } else {
      print('Permission not Provided');
    }
  }

  _buildPopupDialog(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomLeft,
      child: AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Select Option',
          style: TextStyle(color: Colors.white),
        ),
        content: !kIsWeb
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Upload Image from Camera",
                    style: TextStyle(color: Colors.white),
                  ),
                  MaterialButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 90.0,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[Color(0xffCB0338), Color(0xffFF5001)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000),
                            offset: Offset(0.0, 1.5),
                            blurRadius: 1.5,
                          ),
                        ],
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 90.0,
                      ),
                    ),
                    // onPressed: () => startFilePicker(),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ImagePickerFromCamera();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Upload Image from Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                  MaterialButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 90.0,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[Color(0xffCB0338), Color(0xffFF5001)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000),
                            offset: Offset(0.0, 1.5),
                            blurRadius: 1.5,
                          ),
                        ],
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.album,
                        color: Colors.white,
                        size: 90.0,
                      ),
                    ),
                    // onPressed: () => startFilePicker(),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ImagePickerFromGallery();
                    },
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Upload Image from Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                  MaterialButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 90.0,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[Color(0xffCB0338), Color(0xffFF5001)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000),
                            offset: Offset(0.0, 1.5),
                            blurRadius: 1.5,
                          ),
                        ],
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.album,
                        color: Colors.white,
                        size: 90.0,
                      ),
                    ),
                    // onPressed: () => startFilePicker(),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ImagePickerFromGalleryWeb();
                    },
                  ),
                ],
              ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Colors.redAccent,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final String tail;
  final TextStyle titlestyle;
  final TextStyle tailstyle;
  CustomTile(
      {required this.title,
      required this.tail,
      required this.titlestyle,
      required this.tailstyle});

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
