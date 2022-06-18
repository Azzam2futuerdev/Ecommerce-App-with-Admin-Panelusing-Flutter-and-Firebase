import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vdsadmin/category/category.dart';
import 'package:vdsadmin/models/barcodescanner.dart';

import 'package:fluttertoast/fluttertoast.dart';

class InsertDatainFirebase {
  void insertData(
      barcode, name, description, mrp, price, quantity, sellingPrice) async {
    var db = FirebaseFirestore.instance.collection("Products");

    Map<String, dynamic> dataset = {
      "barcode": barcode,
      "name": name,
      "description": description,
      "mrp": mrp,
      "price": price,
      "quantity": quantity,
      "sellingPrice": sellingPrice,
    };

    db.doc(barcode).set(dataset).then((value) => print("success"));
  }

  void deleteData(barcode) async {
    var db = FirebaseFirestore.instance.collection("Products");
    db.doc(barcode).delete().then((value) => print("Deleted"));
  }

  Future uploadImage(imageFile) async {}

  Future upload(barcode, name, description, mrp, price, quantity, sellingPrice,
      imageUrl, Cat) async {
    var db = FirebaseFirestore.instance.collection("Products");

    Map<String, dynamic> dataset = {
      "barcode": barcode,
      "name": name,
      "description": description,
      "quantity": quantity,
      "mrp": double.parse(mrp),
      "image": imageUrl,
      "price": double.parse(price),
      "selling": double.parse(sellingPrice),
      "category": [Cat, null],
      "tags": [Cat, null],
    };

    db.doc(barcode).set(dataset).then(
          (value) => Fluttertoast.showToast(msg: 'Data Updated Sucessfully'),
        );
  }

  Future uploadCategory(index, name, iconUrl, catogoryUrl) async {
    var db = FirebaseFirestore.instance.collection("Category");

    Map<String, dynamic> dataset = {
      'index': index,
      'name': name,
      'tag': name,
      'icon': iconUrl,
      'image': catogoryUrl,
    };

    db.doc(name).set(dataset).then(
          (value) => Fluttertoast.showToast(msg: 'Data Updated Sucessfully'),
        );
  }

  Future DeleteCategory(name) async {
    var db = FirebaseFirestore.instance.collection("Category");

    db.doc(name).delete().then(
          (value) => Fluttertoast.showToast(msg: 'Data Deleted Sucessfully'),
        );
  }

  void DeleteBanner(String name) {
    var db = FirebaseFirestore.instance.collection("Banners");

    db.doc(name).delete().then(
          (value) => Fluttertoast.showToast(msg: 'Data Deleted Sucessfully'),
        );
  }

  void uploadBanner(String? catogoryUrl) async {
    var db = FirebaseFirestore.instance.collection("Banners");

    Map<String, dynamic> dataset = {
      'image': catogoryUrl,
      'screen': "slide",
    };

    db.doc().set(dataset).then(
          (value) => Fluttertoast.showToast(msg: 'Data Updated Sucessfully'),
        );
  }
}
