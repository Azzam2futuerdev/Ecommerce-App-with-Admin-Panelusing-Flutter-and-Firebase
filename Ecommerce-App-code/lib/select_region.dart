//@dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecom/services/auth_provider.dart';
import 'package:ecom/services/data_provider.dart';
import 'home.dart';

class SelectRegion extends StatefulWidget {
  @override
  _SelectRegionState createState() => _SelectRegionState();
}

class _SelectRegionState extends State<SelectRegion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff6fb840),
          centerTitle: true,
          title: Text(
            'Select Your Region',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: dataProvider.region(null),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(
                        '${snapshot.data.documents[index]['region']}',
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      onTap: () {
                        _upload(
                            snapshot.data.documents[index]['city'],
                            snapshot.data.documents[index]['region'],
                            snapshot.data.documents[index]['pincode'],
                            '');
                      },
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Future _upload(
      String city, String region, String pinCode, String delivery) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.amber,
            ),
          );
        },
        barrierDismissible: false);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    CollectionReference reference = Firestore.instance.collection('Users');
    try {
      reference.document(user.uid).setData({
        'city': city,
        'phone': user.phoneNumber,
        'number': user.phoneNumber,
        'region': region,
        'pincode': pinCode,
      }, merge: true);
      await UserProvider.getRegion();
      Navigator.pop(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    } catch (e) {
      print(e.toString());
    }
  }
}
