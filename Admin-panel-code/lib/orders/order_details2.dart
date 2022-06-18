import 'package:flutter/material.dart';

class OrderDet extends StatefulWidget {
  final Map<String, dynamic> mp;
  const OrderDet({Key? key, required this.mp}) : super(key: key);

  @override
  _OrderDetState createState() => _OrderDetState();
}

class _OrderDetState extends State<OrderDet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mp['id']),
      ),
    );
  }
}
