import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vdsadmin/models/data_provider.dart';
// import 'package:image_picker_for_web/image_picker_for_web.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final ScrollController _view = ScrollController();
  TextEditingController name = TextEditingController();
  TextEditingController tag = TextEditingController();
  TextEditingController index = TextEditingController();
  TextEditingController sunname = TextEditingController();
  XFile? category;
  XFile? icon;
  var catogoryUrl;
  var iconUrl;
  late StateSetter _setState;
  final _picker = ImagePicker();
  // final _picker = ImagePickerPlugin();
  List<dynamic> sub = [];
  var url;
  var Imageurl;
  var Iconurl;
  String? Dataseturl;

  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Container(
          child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5, right: 8, left: 8, bottom: 5),
                    child: const Text("Category",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87)),
                  ),
                  Container(
                    child: RaisedButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Add New',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        color: Colors.green,
                        onPressed: () {
                          _addCategory();
                        }),
                  ),
                ]),
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
              stream: dataProvider.category(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      controller: _view,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 4.5,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.hasData) {
                          return customlist(snapshot.data!.docs[index]);
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ],
      )),
    );
  }

  Widget customlist(DocumentSnapshot snapshot) {
    print(snapshot['image']);
    print(snapshot['icon']);
    print(snapshot.id);
    return Card(
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8), topLeft: Radius.circular(8)),
            ),
            child: Image.network(
              snapshot['image'],
              height: 200.0,
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                leading: Container(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    snapshot['icon'],
                    height: 200.0,
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                ),
                title: Text(
                  '${snapshot['name']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Container(
                  width: 80,
                  height: 80,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          _addSub(snapshot.id, snapshot['sub']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot['tags'] != null ? snapshot['tags'].length : 0,
              itemBuilder: (_, i) => ListTile(
                  leading: Container(
                    width: 80,
                    height: 80,
                    child: Image.file(
                      snapshot['tags'][i]['image'],
                      height: 200.0,
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                  ),
                  title: Text(snapshot['tags'][i]['name'].toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black)),
                  subtitle: Text("tag :$i"),
                  trailing: IconButton(
                      icon: Icon(Icons.delete_outline_rounded),
                      tooltip: "delete item",
                      iconSize: 25,
                      onPressed: () {})),
            ),
          ),
        ],
      ),
    );
  }

  _addCategory() {
    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                _setState = setState;
                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 8),
                        const Center(
                          child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("Add Category Details",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87))),
                        ),
                        DottedBorder(
                          child: GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.2,
                              color: Colors.black12,
                              child: catogoryUrl != null
                                  ? Image.network(catogoryUrl)
                                  : const Icon(Icons.image),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialogForCategory(context),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        DottedBorder(
                          child: GestureDetector(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.2,
                              color: Colors.black12,
                              // ignore: unnecessary_null_comparison
                              child: iconUrl != null
                                  ? Image.network(iconUrl)
                                  : const Icon(Icons.image),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialogForIcon(context),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black38,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              controller: name,
                              autofocus: false,
                              decoration: const InputDecoration(
                                hintText: 'Name',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              autofocus: false,
                              controller: index,
                              decoration: const InputDecoration(
                                hintText: 'Index',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        RaisedButton(
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
                            _upload();
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

  Future _upload() async {
    final filePath = 'category/${DateTime.now()}.png';
    final iconPath = 'icon/${DateTime.now()}.png';
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.amber,
          ));
        },
        barrierDismissible: false);

    if (category != null && icon != null) {
      CollectionReference reference =
          FirebaseFirestore.instance.collection('Category');
      reference.doc().set(
        {
          'index': index.text,
          'name': name.text,
          'tag': name.text,
          'icon': iconUrl,
          'image': catogoryUrl,
        },
      ).then((value) {
        setState(() {
          index.text = "";
          tag.text = "";
          // icon = null;
          // category = null;
        });
        setState(() {});
      }).catchError((onError) {
        print(onError.toString());
      });
    }
  }

  _addSub(String document, List<dynamic> s) {
    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              _setState = setState;
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      const SizedBox(height: 8),
                      const Center(
                        child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text("Add Sub Category",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87))),
                      ),
                      const SizedBox(height: 8),
                      DottedBorder(
                        child: GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.2,
                            color: Colors.black12,
                            child: icon != null
                                ? Image.network(icon!.path)
                                : Icon(Icons.image),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialogForIcon(context),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 4),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black38, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextFormField(
                            controller: sunname,
                            autofocus: false,
                            decoration: const InputDecoration(
                                hintText: 'sub category',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 10.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      RaisedButton(
                        color: Colors.lightGreen,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'ADD Sub Category',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          if (s != null) {
                            setState(() {
                              sub = List.from(s);
                            });
                          }
                          _uploadSub(document);
                        },
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  Future _uploadSub(String document) async {
    Navigator.pop(context);
    CollectionReference tags = FirebaseFirestore.instance.collection('Tags');
    final iconPath = 'icon/${DateTime.now()}.png';
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.amber,
            ),
          );
        },
        barrierDismissible: false);
    String iconUrl;
    if (icon != null) {
      final filePath = '${DateTime.now()}.png';
      var file = File(icon!.path);
      var fb = FirebaseStorage.instance;
      var upl = fb.ref().child(filePath).putFile(file).then((value) {
        return value;
      });
      iconUrl = await (await upl).ref.getDownloadURL();
      Fluttertoast.showToast(msg: 'icon Image Uploade Sucessfully');
      var v = {'name': sunname.text, 'image': iconUrl};
      sub.add(v);
      await tags.doc().set(v);
      CollectionReference reference =
          FirebaseFirestore.instance.collection('Category');
      reference.doc(document).set(
        {
          'tags': sub,
        },
      ).then((value) {
        setState(() {
          index.text = "";
          tag.text = "";
          // icon = "";
          // category = "";
          sub = [];
        });
        setState(() {});
      });
    }
  }

  _deleteCategory(String name) {
    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 8),
                        Center(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                  "Are you sure do you want to delete ${name}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87))),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            margin: const EdgeInsets.all(6),
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                gradient: const LinearGradient(colors: [
                                  Color.fromRGBO(116, 116, 191, 1.0),
                                  Color.fromRGBO(52, 138, 199, 1.0)
                                ]),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.transparent, width: 0)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  highlightColor:
                                      Theme.of(context).highlightColor,
                                  splashColor: Theme.of(context).splashColor,
                                  child: const Center(
                                    child: Text(
                                      "delete",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  onTap: () {}),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }));
        });
  }

  _deleteSub(String name) {
    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 8),
                    Center(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                              "Are you sure do you want to delete \n $name ",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87))),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 6, right: 6),
                        margin: EdgeInsets.all(6),
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(116, 116, 191, 1.0),
                              Color.fromRGBO(52, 138, 199, 1.0)
                            ]),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: Colors.transparent, width: 0)),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              highlightColor: Theme.of(context).highlightColor,
                              splashColor: Theme.of(context).splashColor,
                              child: const Center(
                                child: Text(
                                  "delete",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              onTap: () {}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> ImagePickerFromGalleryForCategory() async {
    final picker = ImagePicker();
    var fb = FirebaseStorage.instance;
    XFile? category;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      category = (await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 70));
      if (category != null) {
        var fb = FirebaseStorage.instance;
        final filePath = '${DateTime.now()}.png';
        var file = File(category.path);
        var upl = fb.ref().child(filePath).putFile(file).then((value) {
          return value;
        });
        catogoryUrl = await (await upl).ref.getDownloadURL();
        Fluttertoast.showToast(msg: 'Category Image Uploade Sucessfully');
      } else {
        print('No Category Image Uploaded image Selected');
      }
      setState(() {});
    } else {
      print('Permission not Provided');
    }
  }

  Future<void> ImagePickerFromCameraForCategory() async {
    final picker = ImagePicker();
    var fb = FirebaseStorage.instance;
    XFile? category;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      category = (await picker.pickImage(
          source: ImageSource.camera, imageQuality: 70));
      if (category != null) {
        var fb = FirebaseStorage.instance;
        final filePath = '${DateTime.now()}.png';
        var file = File(category.path);
        var upl = fb.ref().child(filePath).putFile(file).then((value) {
          return value;
        });
        catogoryUrl = await (await upl).ref.getDownloadURL();
        Fluttertoast.showToast(msg: 'Category Image Uploade Sucessfully');
      } else {
        print('No Category Image Uploaded image Selected');
      }
      setState(() {});
    } else {
      print('Permission not Provided');
    }
  }

  _buildPopupDialogForCategory(BuildContext context) {
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
        content: Column(
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
                ImagePickerFromCameraForCategory();
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
                ImagePickerFromGalleryForCategory();
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

  Future<void> ImagePickerFromGalleryForIcon() async {
    final picker = ImagePicker();
    var fb = FirebaseStorage.instance;
    final iconPath = 'icon/${DateTime.now()}.png';
    XFile? icon;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      icon = (await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 70));
      if (icon != null) {
        final filePath = '${DateTime.now()}.png';
        var file = File(icon.path);
        var upl = fb.ref().child(iconPath).putFile(file).then((value) {
          return value;
        });
        iconUrl = await (await upl).ref.getDownloadURL();
        Fluttertoast.showToast(msg: 'icon Image Uploade Sucessfully');
      } else {
        print('No Icon Image Uploaded image Selected');
      }
      setState(() {});
    } else {
      print('Permission not Provided');
    }
  }

  Future<void> ImagePickerFromCameraForIcon() async {
    final picker = ImagePicker();
    var fb = FirebaseStorage.instance;

    final iconPath = 'icon/${DateTime.now()}.png';
    XFile? icon;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      icon = (await picker.pickImage(
          source: ImageSource.camera, imageQuality: 70));
      if (icon != null) {
        final filePath = '${DateTime.now()}.png';
        var file = File(icon.path);
        var upl = fb.ref().child(iconPath).putFile(file).then((value) {
          return value;
        });
        iconUrl = await (await upl).ref.getDownloadURL();
        Fluttertoast.showToast(msg: 'icon Image Uploade Sucessfully');
      } else {
        print('No Icon Image Uploaded image Selected');
      }
      setState(() {});
    } else {
      print('Permission not Provided');
    }
  }

  _buildPopupDialogForIcon(BuildContext context) {
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
        content: Column(
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
                ImagePickerFromCameraForIcon();
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
                ImagePickerFromGalleryForIcon();
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
