import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class SelectedWithPicture extends StatelessWidget {
  Map<String, dynamic> dataset = {};
  SelectedWithPicture(this.dataset);

  Widget _buildProductItem(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: FadeInImage.assetNetwork(
            placeholder: 'images/10.png',
            image: dataset["imageUrl"],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(dataset["name"],
              style: const TextStyle(color: Colors.white, fontSize: 15)),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: _buildProductItem,
      itemCount: dataset.length,
    );
  }
}
