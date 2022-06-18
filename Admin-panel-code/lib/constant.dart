import 'package:flutter/material.dart';

import 'example.dart';

class cards extends StatelessWidget {
  cards(
      {required this.img,
      required this.title,
      required this.subtitle,
      required this.height,
      required this.width,
      required this.colour,
      required this.input});

  final String img;
  final String title;
  final String subtitle;
  final double height;
  final double width;
  final Color colour;
  Widget input;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => input,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: colour,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0.0, 10.0),
                    blurRadius: 10.0)
              ],
            ),
          ),
          Container(
            alignment: FractionalOffset.topCenter,
            child: Image(
              image: AssetImage(
                img,
              ),
              height: height,
              width: width,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class cards2 extends StatelessWidget {
  cards2(
      {required this.img,
      required this.title,
      required this.subtitle,
      required this.height,
      required this.width,
      required this.colour,
      required this.input});

  final String img;
  final String title;
  final String subtitle;
  final double height;
  final double width;
  final Color colour;
  Widget input;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => input,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: colour,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0.0, 10.0),
                    blurRadius: 10.0)
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: FractionalOffset.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: AssetImage(
                        img,
                      ),
                      height: height * 0.5,
                      width: width * 0.5,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Center(
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
