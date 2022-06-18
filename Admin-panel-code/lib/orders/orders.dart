import 'package:flutter/material.dart';
import 'package:vdsadmin/billing/bill.dart';
import 'package:vdsadmin/constant.dart';
import 'package:vdsadmin/orders/offlineorders2.dart';
import 'package:vdsadmin/orders/onlineorders.dart';
import 'package:vdsadmin/orders/onlineorders2.dart';

import '../example.dart';

class Orderspage extends StatefulWidget {
  @override
  _OrderspageState createState() => _OrderspageState();
}

class _OrderspageState extends State<Orderspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: const Color(0xFFE44E4F),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(0.0, 10.0),
                                    blurRadius: 10.0)
                              ]),
                          child: Container(
                            alignment: FractionalOffset.bottomCenter,
                            child: Image.asset(
                              'images/2.png',
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Online Orders',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Orders(),
                      ),
                    ),
                  ),
                  MaterialButton(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: const Color(0xFF6674F1),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(0.0, 10.0),
                                    blurRadius: 10.0)
                              ]),
                          child: Container(
                            alignment: FractionalOffset.bottomCenter,
                            child: Image.asset(
                              'images/3.png',
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: const TextSpan(
                              text: 'Offline Orders',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Example(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              MaterialButton(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color(0xFFE44E4F),
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0.0, 10.0),
                                blurRadius: 10.0)
                          ]),
                      child: Container(
                        alignment: FractionalOffset.bottomCenter,
                        child: Image.asset(
                          'images/2.png',
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'Online Orders 2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Orders2(),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              MaterialButton(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color(0xFF6674F1),
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0.0, 10.0),
                                blurRadius: 10.0)
                          ]),
                      child: Container(
                        alignment: FractionalOffset.bottomCenter,
                        child: Image.asset(
                          'images/3.png',
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.3,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Offline Orders 2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OfflineOrders2(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
