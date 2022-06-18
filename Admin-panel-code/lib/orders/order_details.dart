import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vdsadmin/models/data_provider.dart';
import 'package:vdsadmin/orders/items_details.dart';

class OrderDetails extends StatefulWidget {
  // final DocumentSnapshot snapshot;
  final Map<String, dynamic> mp;
  const OrderDetails({Key? key, required this.mp}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String? status;
  DateFormat format = DateFormat.yMMMMd('en_US');
  DateFormat time = DateFormat.jm();
  String? delivery;

  @override
  void initState() {
    // TODO: implement initState
    status = widget.mp['status'];
    delivery = '${widget.mp['delivery']}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffebebeb),
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0,
          // title: Text(
          //   widget.mp['phone'],
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          // ),
          title: Row(
            children: [
              Text(
                widget.mp['phone'],
                style: TextStyle(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: 10,
              ),
              DropdownButton(
                dropdownColor: Colors.blueGrey,
                value: status,
                icon:
                    const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                iconSize: 24,
                elevation: 16,
                underline: Container(),
                hint: Text('Status'),
                style: TextStyle(color: Colors.white, fontSize: 16),
                items: [
                  'Order Placed',
                  'Order Accepted',
                  'Order PickedUp',
                  'Order Completed'
                ].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _update,
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            const ListTile(
                              title: Text(
                                'Customer Details',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                  child: Icon(Icons.person_outline)),
                              title: Text('${widget.mp['name']}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                '${widget.mp['phone']}',
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.local_shipping_outlined),
                              title: Text('Shipping Address',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                '${widget.mp['address']}',
                              ),
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const ListTile(
                              title: Text(
                                'Price Details',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            CustomTile(
                                title: 'Total Cost',
                                tail: '₹${widget.mp['sub']}',
                                titlestyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 16),
                                tailstyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                    fontSize: 16)),
                            CustomTile(
                                title: 'Delivery Charge',
                                tail: '₹${widget.mp['delivery']}',
                                titlestyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 16),
                                tailstyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                    fontSize: 16)),
                            CustomTile(
                                title: 'Sub Total',
                                tail:
                                    '₹${widget.mp['sub'] + widget.mp['delivery']}',
                                titlestyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 16),
                                tailstyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                    fontSize: 16)),
                            CustomTile(
                                title: 'Discount',
                                tail:
                                    '${((widget.mp['saving'] / widget.mp['sub']) * 100).floor()}% OFF',
                                titlestyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 16),
                                tailstyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff6fb840),
                                    fontSize: 16)),
                            CustomTile(
                                title: 'Total Saving',
                                tail: '- ₹${widget.mp['saving']}',
                                titlestyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 16),
                                tailstyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff6fb840),
                                    fontSize: 16)),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Order Total:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        'including all taxes',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(112, 112, 112, 1),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "₹${widget.mp['total']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Card(
                          elevation: 0,
                          child: Column(
                            children: [
                              const ListTile(
                                title: Text(
                                  'Booking Details',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListTile(
                                title: Text('${widget.mp['booking']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                subtitle: Text.rich(TextSpan(
                                    text:
                                        '${format.format(DateTime.fromMicrosecondsSinceEpoch(widget.mp['booking']))}   ',
                                    style: TextStyle(),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${time.format(DateTime.fromMicrosecondsSinceEpoch(widget.mp['booking']))}',
                                      )
                                    ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border:
                                          Border.all(color: Colors.black26)),
                                  child: DropdownButton(
                                    value: status,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    isExpanded: true,
                                    underline: Container(),
                                    hint: Text('Status'),
                                    style: TextStyle(color: Colors.black),
                                    items: [
                                      'Order Placed',
                                      'Order Accepted',
                                      'Order PickedUp',
                                      'Order Completed'
                                    ].map((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: _update,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10)
                            ],
                          ),
                        ),
                      ],
                    )),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            SizedBox(height: 10),
            Card(
              elevation: 0,
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      'Item Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  //dataProvider.orderItems(widget.mp['id']),
                  StreamBuilder<QuerySnapshot>(
                    stream: dataProvider.orderItems(widget.mp['id']),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData) {
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> data =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              // return Text("Full Name: ${data['image']} ");
                              return ItemsDetails(
                                data: data,
                              );
                            });
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data! as Map<String, dynamic>;
                        return Text("Full Name: ${data['image']} ");
                      }

                      return Text("loading");
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text(
                      'DeliveryBoy Details',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: dataProvider.employee(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      // if (snapshot.connectionState ==
                      //     ConnectionState.waiting) {
                      //   return Center(
                      //       child: CircularProgressIndicator());
                      // }
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> data =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return ListTile(
                              leading: Container(
                                  width: 60,
                                  height: 60,
                                  child: Image.network(
                                    data['image'],
                                  )),
                              title: Text('${data['name']}'),
                              subtitle: Text('${data['phone']}'),
                              trailing: Radio(
                                groupValue: delivery,
                                value: snapshot.data!.docs[index].id,
                                onChanged: (value) {
                                  _deliveryBoy(snapshot.data!.docs[index]);
                                },
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void _update(String? value) async {
    CollectionReference referencer =
        FirebaseFirestore.instance.collection('Orders');
    try {
      referencer.doc(widget.mp['id']).update({
        'status': value,
      });
      setState(() {
        status = value;
      });
    } catch (e) {}
  }

  Future _deliveryBoy(DocumentSnapshot snapshot) async {
    CollectionReference referencer =
        FirebaseFirestore.instance.collection('Orders');
    try {
      referencer.doc(widget.mp['id']).update({
        'deliveryBoy': snapshot.id,
        'boyName': snapshot['name'],
        'boyPhone': snapshot['phone'],
        'status': 'Order PickedUp'
      });
      setState(() {
        delivery = snapshot.id;
        status = 'Order PickedUp';
      });
    } catch (e) {}
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final String tail;
  final TextStyle titlestyle;
  final TextStyle tailstyle;
  CustomTile(
      {required this.title,
      required this.tail,
      required this.titlestyle,
      required this.tailstyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Row(
        children: [
          Expanded(
            child: Align(
              child: Text(
                '$title',
                style: titlestyle,
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(
            child: Align(
              child: Text(
                '$tail',
                style: tailstyle,
              ),
              alignment: Alignment.centerRight,
            ),
          )
        ],
      ),
    );
  }
}
