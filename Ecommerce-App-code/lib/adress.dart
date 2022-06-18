//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/services/auth_provider.dart';
import 'package:ecom/services/data_provider.dart';

import 'checkout.dart';

class Address extends StatefulWidget {
  final String type;
  final double sub;
  final double saving;
  final double total;
  final String pincode;
  final QuerySnapshot snapshot;

  Address(this.type, this.sub, this.saving, this.total, this.pincode,
      this.snapshot);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  int value = 0;
  String name;
  String address;
  TextEditingController editName = new TextEditingController();
  TextEditingController house = new TextEditingController();
  TextEditingController locality = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController pincode = new TextEditingController();
  List<dynamic> l = [];
  double delivery = 0;

  @override
  void initState() {
    // TODO: implement initState
    pincode.text = widget.pincode;
    UserProvider.address != null ? l = List.from(UserProvider.address) : null;
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
          'Shipping Address',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12),
            child: Text('Choose your location',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
              stream: dataProvider.region(widget.pincode),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.documents.length > 0) {
                  delivery = double.parse(
                      snapshot.data.documents[0]['delivery'].toString());
                  city.text = snapshot.data.documents[0]['city'];
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Card(
                    elevation: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            UserProvider.address != null ? l.length + 1 : 1,
                        itemBuilder: (BuildContext context, int index) {
                          return index <= l.length - 1
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    trailing: Radio(
                                      value: address,
                                      groupValue: l[index]['address'],
                                      onChanged: (v) {
                                        if (widget.pincode ==
                                            l[index]['pincode']) {
                                          setState(() {
                                            address = l[index]['address'];
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      CheckOut(
                                                          widget.type,
                                                          '${l[index]['name']}',
                                                          '${l[index]['address']}',
                                                          delivery,
                                                          widget.sub,
                                                          widget.saving,
                                                          widget.total,
                                                          widget.snapshot)));
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please select a valid delivery address");
                                        }
                                      },
                                    ),
                                    title: Text(
                                      '${l[index]['name']}',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text('${l[index]['address']}',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        address = l[index]['address'];
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  CheckOut(
                                                      widget.type,
                                                      '${l[index]['name']}',
                                                      '${l[index]['address']}',
                                                      delivery,
                                                      widget.sub,
                                                      widget.saving,
                                                      widget.total,
                                                      widget.snapshot)));
                                    },
                                  ),
                                )
                              : index == l.length
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: ListTile(
                                          leading: Icon(
                                              Icons.local_shipping_outlined),
                                          title: Text(
                                            'Add Address',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          onTap: () {
                                            _bottomSheet();
                                          },
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: ListTile(
                                          leading: Icon(
                                              Icons.local_shipping_outlined),
                                          title: Text(
                                            'Add Address',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          onTap: () {
                                            _bottomSheet();
                                          },
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                    );
                        },
                      ),
                    ),
                  ),
                );
              }),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  _bottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      tileColor: Colors.green.withOpacity(0.2),
                      title: Text(
                        'Add delivery address',
                        style: GoogleFonts.poppins(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
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
                              colors: [Colors.green, Colors.green],
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
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () async {
                              var v = {
                                'name': editName.text,
                                'pincode': pincode.text,
                                'address':
                                    '${house.text},${locality.text},${city.text},${pincode.text}'
                              };
                              l.add(v);
                              FirebaseUser user =
                                  await FirebaseAuth.instance.currentUser();
                              CollectionReference reference =
                                  Firestore.instance.collection('Users');
                              try {
                                reference.document(user.uid).setData({
                                  'address': l,
                                }, merge: true);
                                UserProvider.getRegion();
                                _state();
                                Navigator.pop(context);
                              } catch (e) {
                                print(e.toString());
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
}
