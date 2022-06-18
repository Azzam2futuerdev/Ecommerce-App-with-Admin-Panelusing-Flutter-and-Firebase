//@dart=2.9

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Banners extends StatelessWidget {
  const Banners({
    Key key,
    this.snapshot,
  }) : super(key: key);

  final QuerySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Carousel(
          images: snapshot.documents
              .map((e) => CachedNetworkImage(
                    imageUrl: e.data['image'],
                    fit: BoxFit.fill,
                  ))
              .toList(),
          dotBgColor: Colors.transparent,
          dotSize: 4,
          autoplayDuration: Duration(seconds: 5),
          onImageTap: (index) async {}),
    );
  }
}
