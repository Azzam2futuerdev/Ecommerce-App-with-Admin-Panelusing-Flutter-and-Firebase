import 'package:flutter/material.dart';

class ItemsDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  const ItemsDetails({Key? key, required this.data}) : super(key: key);

  @override
  _ItemsDetailsState createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  @override
  Widget build(BuildContext context) {
    print('HELLO JII');
    print(widget.data['image']);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 2),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: widget.data['image'] != null
                      ? Image.network(widget.data['image'])
                      : Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Icon(Icons.photo_size_select_actual_outlined)),
                ),
              ),
            ),
            Expanded(
                flex: 7,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        '${widget.data['name']}',
                        style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5),
                      ),
                      subtitle: Text(
                        widget.data['description'] ??
                            ' ${widget.data['quantity']}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4)),
                        padding: EdgeInsets.all(6),
                        child: Row(
                          children: [
                            Text(
                              '${widget.data['quantity']}',
                              style: TextStyle(),
                            ),
                            Padding(padding: EdgeInsets.only(right: 8)),
                            Text(
                              '${widget.data['pieces']} pieces',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                      child: Row(
                        children: [
                          Text(
                              '₹${widget.data['price']}X${widget.data['pieces']} = ',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                          Text('₹${widget.data['total']}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    )
                  ],
                ))
          ]),
    );
  }
}
