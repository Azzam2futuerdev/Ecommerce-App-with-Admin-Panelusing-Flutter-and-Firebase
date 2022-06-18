import 'package:flutter/material.dart';
import 'home.dart';

class OrderSuccessful extends StatefulWidget {
  final String id;

  OrderSuccessful(this.id);

  @override
  _OrderSuccessfulState createState() => _OrderSuccessfulState();
}

class _OrderSuccessfulState extends State<OrderSuccessful> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 45,child: Icon(Icons.check,size: 40,color: Colors.white,),backgroundColor: Color(0xff32CC34),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Order Successful!',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            ),
            Text('Order ID: ${widget.id}',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
            Padding(
              padding: EdgeInsets.only(top: 12,left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12,left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1,bottom: 8),
              child: Text('Soon you will receive your order status',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
            ),
            Text('Thank You',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
            SizedBox(height: 60,),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Container(
                height: 50.0,
                margin: EdgeInsets.only(left: 16,right: 16),
                child: RaisedButton(elevation: 1,
                  onPressed: ()async{
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>HomeScreen()));
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xff32CC34),Color(0xff32CC34)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(80.0)
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Continue Shopping",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
