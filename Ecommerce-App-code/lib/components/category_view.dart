//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryView extends StatelessWidget {
  final DocumentSnapshot snapshot;
  final Function onClick;
  const CategoryView({Key key, this.snapshot, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                child: CachedNetworkImage(
                  imageUrl: snapshot.data['icon'],
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 4),
              Text('${snapshot.data['tag']}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
      ),
      onTap: onClick,
    );
  }
}
