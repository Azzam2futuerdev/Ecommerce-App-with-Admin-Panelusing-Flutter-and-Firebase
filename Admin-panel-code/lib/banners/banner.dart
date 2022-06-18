import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vdsadmin/banners/bannercard.dart';
import 'package:vdsadmin/category/categorycard.dart';
import 'package:vdsadmin/models/data_provider.dart';
import 'package:vdsadmin/models/firebase.service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BannerDisplay extends StatefulWidget {
  @override
  _BannerDisplayState createState() => _BannerDisplayState();
}

class _BannerDisplayState extends State<BannerDisplay> {
  late StateSetter sete;
  final ScrollController view = ScrollController();
  TextEditingController description = TextEditingController();
  TextEditingController index = TextEditingController();
  XFile? Banner;
  String? catogoryUrl;
  String? iconUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      height: MediaQuery.of(context).size.height,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 5, right: 8, left: 8, bottom: 5),
                      child: const Text("Banner",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                              color: Colors.white)),
                    ),
                    Container(
                      child: MaterialButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Add New Banner',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          color: Colors.green,
                          onPressed: () {
                            addBanner();
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: dataProvider.banners(''),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      return Material(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 10,
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 8.0,
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              String id = document.id;
                              return BannerCard(
                                data: data,
                                id: id,
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void addBanner() {
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
                sete = setState;
                return Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 8),
                        const Center(
                          child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("Add Banner",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white))),
                        ),
                        DottedBorder(
                          child: GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.2,
                              color: Colors.black12,
                              child: catogoryUrl != null
                                  ? Image.network(catogoryUrl!)
                                  : const Icon(Icons.image),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    buildPopupDialogForBanner(context),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
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
                            if (catogoryUrl != null) {
                              InsertDatainFirebase().uploadBanner(catogoryUrl);
                              index.clear();
                              description.clear();
                              iconUrl = null;
                              catogoryUrl = null;
                              Banner = null;
                              Navigator.of(context).pop();
                            } else {
                              CircularProgressIndicator(
                                backgroundColor: Colors.amber,
                              );
                            }
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

  Future<void> ImagePickerFromGalleryForBannerWeb() async {
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
        var upl = fb.ref().child("Banner/$filePath").putData(uploadFile!);
        String downloadurl = await (await upl).ref.getDownloadURL();
        print(downloadurl);
        setState(() {
          catogoryUrl = downloadurl;
        });

        Fluttertoast.showToast(msg: 'Image Uploade Sucessfully');
      } catch (e) {
        print(e);
      }
    } else {
      // TODO: show "file not selected" snack bar
    }
  }

  Future<void> ImagePickerFromGalleryForBanner() async {
    final picker = ImagePicker();
    var fb = FirebaseStorage.instance;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      Banner = (await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 70));
      if (Banner != null) {
        var fb = FirebaseStorage.instance;
        final filePath = '${DateTime.now()}.png';
        var file = File(Banner!.path);
        var upl = fb.ref().child(filePath).putFile(file).then((value) {
          return value;
        });
        catogoryUrl = await (await upl).ref.getDownloadURL();
        setState(() {});
        Fluttertoast.showToast(msg: 'Banner Image Uploade Sucessfully');
      } else {
        print('No Banner Image Uploaded image Selected');
      }
      setState(() {});
    } else {
      print('Permission not Provided');
    }
  }

  Future<void> ImagePickerFromCameraForBanner() async {
    final picker = ImagePicker();
    var fb = FirebaseStorage.instance;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      Banner = (await picker.pickImage(
          source: ImageSource.camera, imageQuality: 70));
      if (Banner != null) {
        var fb = FirebaseStorage.instance;
        final filePath = '${DateTime.now()}.png';
        var file = File(Banner!.path);
        var upl = fb.ref().child(filePath).putFile(file).then((value) {
          return value;
        });
        catogoryUrl = await (await upl).ref.getDownloadURL();
        setState(() {});
        Fluttertoast.showToast(msg: 'Banner Image Uploade Sucessfully');
      } else {
        print('No Banner Image Uploaded image Selected');
      }
      setState(() {});
    } else {
      print('Permission not Provided');
    }
  }

  buildPopupDialogForBanner(BuildContext context) {
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
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 90.0,
                      ),
                    ),
                    // onPressed: () => startFilePicker(),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ImagePickerFromCameraForBanner();
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
                      child: const Icon(
                        Icons.album,
                        color: Colors.white,
                        size: 90.0,
                      ),
                    ),
                    // onPressed: () => startFilePicker(),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ImagePickerFromGalleryForBanner();
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
                      child: const Icon(
                        Icons.album,
                        color: Colors.white,
                        size: 90.0,
                      ),
                    ),
                    // onPressed: () => startFilePicker(),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ImagePickerFromGalleryForBannerWeb();
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

  void _addSub(id, snapshot) {}
}
