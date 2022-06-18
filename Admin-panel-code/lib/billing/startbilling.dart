import 'package:flutter/material.dart';
import 'package:vdsadmin/billing/bill.dart';
import 'package:vdsadmin/constant.dart';

import '../example.dart';

class StartBilling extends StatefulWidget {
  @override
  _StartBillingState createState() => _StartBillingState();
}

class _StartBillingState extends State<StartBilling> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing '),
      ),
      body: Column(
        children: [
          SizedBox(
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
                          text: 'Add Item',
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
                    builder: (_) => Bill(),
                  ),
                ),
              ),

              // cards2(
              //   colour: const Color(0xFFE44E4F),
              //   img: 'images/2.png',
              //   width: MediaQuery.of(context).size.width * 0.4,
              //   height: MediaQuery.of(context).size.height * 0.4,
              //   title: 'Add Item',
              //   subtitle: '+',
              //   input: Bill(),
              // ),
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
                          text: 'Add User',
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

              // cards2(
              //   colour: const Color(0xFF6674F1),
              //   img: 'images/3.png',
              //   width: MediaQuery.of(context).size.width * 0.4,
              //   height: MediaQuery.of(context).size.height * 0.4,
              //   title: ' Add User ',
              //   subtitle: 'Contacts',
              //   input: Example(),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
