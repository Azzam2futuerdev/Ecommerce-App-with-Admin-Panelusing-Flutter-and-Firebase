import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:vdsadmin/widgets/raised_gradient_button.dart';

class NotifyAll extends StatefulWidget {
  const NotifyAll({Key? key}) : super(key: key);

  @override
  _NotifyAllState createState() => _NotifyAllState();
}

class _NotifyAllState extends State<NotifyAll> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    var hg = MediaQuery.of(context).size.height;

    form(String title, String hint, TextEditingController controller, Icon ic) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white)),
              child: TextField(
                controller: controller,
                showCursor: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "$hint",
                  prefixIcon: ic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    form2(
        String title, String hint, TextEditingController controller, Icon ic) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$title',
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.white)),
              child: TextField(
                maxLines: null,
                controller: controller,
                showCursor: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "$hint",
                  prefixIcon: ic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.blueGrey,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  form(
                    'Enter Title of notification',
                    'Title',
                    name,
                    const Icon(
                      Icons.card_giftcard_sharp,
                      color: Colors.white,
                    ),
                  ),
                  form2(
                    'Enter Content',
                    'Message',
                    description,
                    const Icon(
                      Icons.description,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedGradientButton(
                      child: const Text(
                        'Send Notification',
                        style: TextStyle(color: Colors.white),
                      ),
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xffCB0338), Color(0xffFF5001)],
                      ),
                      onPressed: () {
                        List<String> id = [];
                        FirebaseFirestore.instance
                            .collection('Users')
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            print(doc["city"]);
                            if (doc["onesignalTokenID"] != "") {
                              id.add(doc["onesignalTokenID"]);
                              sendNotification([doc["onesignalTokenID"]],
                                  name.text, description.text);
                              print(' id is : ${doc["onesignalTokenID"]}');
                            }
                          });
                        });
                        // sendNotification(id, name.text, description.text);

                        Fluttertoast.showToast(msg: 'Sending notification');
                        Navigator.of(context).pop();
                      },
                    ),
                  ),

                  // Center(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       sendNotification(
                  //           ['80577527-848c-4985-84cb-01f895bac1eb'],
                  //           name.text,
                  //           description.text);
                  //     },
                  //     child: Container(
                  //       width: 70,
                  //       padding: EdgeInsets.all(10),
                  //       decoration: BoxDecoration(
                  //           color: Colors.green,
                  //           borderRadius: BorderRadius.circular(8)),
                  //       child: Text("Send"),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Response> sendNotification(
      List<String> tokenIdList, String heading, String contents) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id":
            'd43fa4f9-2fa5-48a3-a184-49636c9d96c5', //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon":
            "https://firebasestorage.googleapis.com/v0/b/ecommerce-26b18.appspot.com/o/vishal-departmental-store--murlipura-jaipur-gift-shops-1ntp73w.jpg?alt=media&token=80bb5211-1f89-4075-a289-2aa238bdf51a",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }
}
