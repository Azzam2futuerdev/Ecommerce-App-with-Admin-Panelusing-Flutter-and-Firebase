
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_provider.dart';

class DataProvider{

  final db=Firestore.instance;

  Stream<QuerySnapshot>banners(String filter){
    return db.collection('Banners').where('screen',isEqualTo: filter).snapshots();
  }

  Stream<QuerySnapshot>region(String filter){
    if(filter!=null&&filter.isNotEmpty){
      return db.collection('Regions').where('pincode',isEqualTo: filter).snapshots();
    }
    return db.collection('Regions').snapshots();
  }

  Stream<QuerySnapshot>category(){
    return db.collection('Category').snapshots();
  }

  Stream<QuerySnapshot>products(String filter){
    if(filter!=null){
      return db.collection('Products').where('category',arrayContains: filter).snapshots();
    }
    return db.collection('Products').limit(20).snapshots();
  }

  Stream<QuerySnapshot>shops(String filter){
    return db.collection('Shops').where('category',isEqualTo: filter).limit(10).snapshots();
  }


  Stream<QuerySnapshot>shopsCategory(String doc){
    return db.collection('Shops').document(doc).collection('Category').limit(10).snapshots();
  }


  Stream<QuerySnapshot>cart(){
    return db.collection('Users').document(UserProvider.user.uid).collection('Cart').snapshots();
  }

  Stream<DocumentSnapshot>cartCheck(String doc){
    return db.collection('Users').document(UserProvider.user.uid).collection('Cart').document(doc).snapshots();
  }

  Stream<DocumentSnapshot>profile(){
    return db.collection('Users').document(UserProvider.user.uid).snapshots();
  }

  Stream<QuerySnapshot>orders(){
    return db.collection('Orders').where('user',isEqualTo: UserProvider.user.uid).snapshots();
  }

  Stream<QuerySnapshot>orderItems(String id){
    return db.collection('Items').where('orderID',isEqualTo: id).snapshots();
  }

}

DataProvider dataProvider=new DataProvider();