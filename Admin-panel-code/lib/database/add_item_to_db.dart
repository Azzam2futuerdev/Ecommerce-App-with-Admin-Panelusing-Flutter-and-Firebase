import 'dart:io' as android;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timelines/timelines.dart';
import 'package:vdsadmin/models/barcodescanner.dart';
import 'package:vdsadmin/models/data_provider.dart';
import 'package:vdsadmin/models/firebase.service.dart';
import 'package:vdsadmin/widgets/raised_gradient_button.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ShopRegister extends StatefulWidget {
  const ShopRegister({Key? key}) : super(key: key);

  @override
  _ShopRegisterState createState() => _ShopRegisterState();
}

class _ShopRegisterState extends State<ShopRegister> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController mrp = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController selling = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController barcode = TextEditingController();
  late String tags1;
  var category1;
  late String tags2;
  late String category2;
  late String pincode;
  int index = 0;
  bool check = false;
  bool imageselected = false;
  XFile? bannerFile;
  bool _load = false;
  var url;
  String? Dataseturl;

  // final _picker = ImagePickerPlugin();
  String _scanBarcode = 'Unknown';
  bool isImage = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    mrp.dispose();
    price.dispose();
    selling.dispose();
    quantity.dispose();
    barcode.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
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
      _scanBarcode = barcodeScanRes;
      barcode.text = barcodeScanRes;
      _barcode = barcodeScanRes;
    });
  }

  String? _barcode;
  late bool visible;
  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    var hg = MediaQuery.of(context).size.height;

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.blueGrey,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Enter barcode',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Colors.white)),
                          child: Center(
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
                                  setState(() {
                                    _barcode = barcode;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.qr_code_2,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            _barcode == null
                                                ? 'SCAN BARCODE'
                                                : 'BARCODE: $_barcode',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // form(
                  //   'Enter barcode',
                  //   'Barcode',
                  //   barcode,
                  //   const Icon(
                  //     Icons.qr_code_2,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  RaisedGradientButton(
                    child: const Text(
                      'Scan BarCode',
                      style: TextStyle(color: Colors.white),
                    ),
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xffCB0338), Color(0xffFF5001)],
                    ),
                    onPressed: () => scanBarcodeNormal(),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  form(
                    'Enter Product Name',
                    'Product name',
                    name,
                    const Icon(
                      Icons.card_giftcard_sharp,
                      color: Colors.white,
                    ),
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
                                width: MediaQuery.of(context).size.width * 0.7,
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
                  form(
                    'Enter Product Description',
                    'Product Description',
                    description,
                    const Icon(
                      Icons.description,
                      color: Colors.white,
                    ),
                  ),
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
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(8)),
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
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return DropdownMenuItem(
                                value: data['tag'],
                                child: Text(data['tag']),
                              );
                            }).toList(),
                          );
                        }),
                  ),

                  form(
                    'Enter M.R.P.',
                    ' M.R.P.',
                    mrp,
                    const Icon(
                      Icons.attach_money,
                      color: Colors.white,
                    ),
                  ),
                  form(
                    'Enter Cost Price',
                    'purchasing Price',
                    price,
                    const Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                    ),
                  ),
                  form(
                    'Enter Our Selling Price',
                    'V.D.S. Price',
                    selling,
                    const Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                    ),
                  ),
                  form(
                    'Enter Quantity',
                    ' Stock Quantity',
                    quantity,
                    const Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedGradientButton(
                      child: const Text(
                        'Add to Database',
                        style: TextStyle(color: Colors.white),
                      ),
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xffCB0338), Color(0xffFF5001)],
                      ),
                      onPressed: () {
                        Dataseturl == null
                            ? const CircularProgressIndicator()
                            : InsertDatainFirebase().upload(
                                _barcode,
                                name.text,
                                description.text,
                                mrp.text,
                                price.text,
                                quantity.text,
                                selling.text,
                                Dataseturl,
                                category1);
                        name.clear();
                        description.clear();
                        mrp.clear();
                        price.clear();
                        selling.clear();
                        quantity.clear();
                        barcode.clear();
                        Dataseturl = null;
                        url = null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
