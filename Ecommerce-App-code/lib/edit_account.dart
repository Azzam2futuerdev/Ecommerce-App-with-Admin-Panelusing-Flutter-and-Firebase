//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:ecom/services/auth_provider.dart';

class EditAccount extends StatefulWidget {
  final DocumentSnapshot snapshot;

  EditAccount(this.snapshot);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController mail = new TextEditingController();
  TextEditingController editName = new TextEditingController();
  TextEditingController house = new TextEditingController();
  TextEditingController locality = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController pincode = new TextEditingController();
  List<dynamic> l = [];
  String url;
  File img;

  @override
  void initState() {
    // TODO: implement initState
    name.text = widget.snapshot.data['name'];
    phone.text = widget.snapshot.data['number'];
    mail.text = widget.snapshot.data['mail'];
    url = widget.snapshot.data['profile'];
    pincode.text = widget.snapshot.data['pincode'];
    city.text = widget.snapshot.data['city'];
    widget.snapshot.data['address'] != null
        ? l = List.from(widget.snapshot.data['address'])
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color(0xff6fb840),
        title: Text(
          'Edit Account',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: 100,
              height: 100,
              padding: EdgeInsets.all(4),
              child: Neumorphic(
                style: NeumorphicStyle(
                    color: Colors.white,
                    boxShape: NeumorphicBoxShape.circle(),
                    shadowLightColor: Colors.white),
                padding: EdgeInsets.all(4),
                child: GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70.0),
                    child: img != null
                        ? Image.file(img)
                        : url != null && url.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(
                                radius: 67,
                                backgroundColor: Color(0xff6fb840),
                                child: Icon(
                                  Icons.person,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                  ),
                  onTap: () {
                    _bottom2(context);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
              child: TextField(
                controller: name,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Tell us your name',
                    labelText: 'Name*',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.blue,
                    ),
                    suffixStyle: const TextStyle(color: Colors.green)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
              child: TextField(
                controller: mail,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'example@gmail.com',
                    labelText: 'Mail ID',
                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      color: Colors.blue,
                    ),
                    suffixStyle: const TextStyle(color: Colors.green)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: phone,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'Phone Number',
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                    prefixText: ' ',
                    suffixText: 'IND',
                    suffixStyle: const TextStyle(color: Colors.green)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 12, bottom: 12),
                child: Text(
                  'Shipping Address',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 140,
              child: ListView(
                  padding: EdgeInsets.only(left: 12),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      l != null && l.isNotEmpty ? l.length + 1 : 1, (index) {
                    return l != null && l.isNotEmpty && l.length > index
                        ? Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ListTile(
                                title: Text(
                                  '${l[index]['name']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '${l[index]['address']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            child: Card(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.local_shipping_outlined),
                                    SizedBox(height: 10),
                                    Text(
                                      'Add Shipping Address',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              _bottom();
                            },
                          );
                  }).toList()),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 50.0,
              color: Colors.transparent,
              margin: EdgeInsets.only(left: 16, right: 16),
              child: RaisedButton(
                elevation: 1,
                onPressed: () async {
                  _upload();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff6fb840), Color(0xff6fb840)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(80.0)),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _bottom() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      tileColor: Colors.green.shade50,
                      title: Text(
                        'Add delivery address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                    _textEdit(editName, 'Name'),
                    _textEdit(house, 'House/Flat no'),
                    _textEdit(locality, 'Street name/Land mark'),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: city,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade50, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'City',
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: pincode,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          labelText: 'Pincode',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Container(
                        width: double.infinity,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          gradient: new LinearGradient(
                              colors: [Color(0xff6fb840), Color(0xff6fb840)],
                              begin: FractionalOffset(0.2, 0.2),
                              end: FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: MaterialButton(
                            highlightColor: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 42.0),
                              child: Text(
                                "Save Address",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () async {
                              if (editName.text.isNotEmpty &&
                                  house.text.isNotEmpty &&
                                  locality.text.isNotEmpty) {
                                var v = {
                                  'name': editName.text,
                                  'pincode': pincode.text,
                                  'address':
                                      '${house.text},${locality.text},${city.text},${pincode.text}'
                                };
                                l.add(v);
                                _state();
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please enter all mandatory fields");
                              }
                            }),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future _upload() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        barrierDismissible: false);
    if (img != null) {
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("Profile")
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      final task = ref.putFile(img);
      await task.onComplete;
      url = await ref.getDownloadURL();
      setState(() {});
    }
    CollectionReference reference = Firestore.instance.collection('Users');
    try {
      reference.document(user.uid).setData({
        'name': name.text,
        'mail': mail.text,
        'profile': url,
        'address': l,
      }, merge: true);
      await UserProvider.getRegion();
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Saved');
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Something went wrong! Please try again');
    }
  }

  _state() {
    setState(() {});
  }

  _textEdit(TextEditingController controller, String lable) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: lable,
        ),
      ),
    );
  }

  _bottom2(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(// You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: Text(
                        'Choose Profile',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text("Camera"),
                      onTap: () async {
                        final image = await ImagePicker.pickImage(
                            source: ImageSource.camera,
                            maxWidth: 512,
                            maxHeight: 512,
                            imageQuality: 70);
                        if (image != null) {
                          setState(() {
                            img = image;
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text("Gallery"),
                      onTap: () async {
                        final image = await ImagePicker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 512,
                            maxHeight: 512,
                            imageQuality: 70);
                        if (image != null) {
                          setState(() {
                            img = image;
                          });
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
