//@dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider {
  static FirebaseUser user;
  static List<dynamic> address;
  static String pincode;
  static String name;
  static String profile;
  static FirebaseAuth auth = FirebaseAuth.instance;

  static getUser() async {
    auth.onAuthStateChanged.listen((event) => {user = event});
  }

  static getRegion() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      CollectionReference reference = Firestore.instance.collection('Users');
      reference.document(user.uid).get().then((value) {
        name = value.data['name'];
        address = value.data['address'];
        pincode = value.data['pincode'];
        profile = value.data['profile'];
      }).catchError((onError) {
        print(onError);
      });
    }
  }
}
