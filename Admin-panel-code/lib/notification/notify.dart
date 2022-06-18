import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vdsadmin/models/data_provider.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
CollectionReference adminTokenRef =
    FirebaseFirestore.instance.collection('Users');

class UserViewer extends StatefulWidget {
  @override
  _UserViewerState createState() => _UserViewerState();
}

class _UserViewerState extends State<UserViewer> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
      padding:
          const EdgeInsets.only(top: 40.0, right: 20.0, left: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Users',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      flex: 3,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: dataProvider.User(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            List<DocumentSnapshot> userList = [];
                            snapshot.data!.docs.map((e) {
                              userList.add(e);
                            }).toList();

                            print(userList[0]);

                            return ListView.builder(
                              itemCount: userList.length,
                              itemBuilder: (context, pos) {
                                return Notify(
                                  jobTitle: userList[pos]["name"],
                                  colorBg: Colors.grey,
                                  colorText: Colors.white,
                                  userId: userList[pos]["uid"],
                                  jobDesc: userList[pos]["phone"],
                                  tokenId: userList[pos]["onesignalTokenID"],
                                );
                              },
                            );
                          }))
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class Notify extends StatefulWidget {
  const Notify(
      {Key? key,
      required this.jobTitle,
      required this.jobDesc,
      required this.userId,
      required this.colorBg,
      required this.colorText,
      required this.tokenId})
      : super(key: key);

  final String jobTitle;
  final String jobDesc;
  final String userId;
  final String tokenId;
  final Color colorBg;
  final Color colorText;

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
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
            "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 8, top: 25, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(3.0, 3.0),
                color: Colors.grey.shade500.withOpacity(0.1),
                blurRadius: 6.0,
                spreadRadius: 2.0,
              ),
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.jobTitle,
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.jobDesc),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () =>
                sendNotification([widget.tokenId], "Testing 123", "Sanjay"),
            child: Container(
              width: 70,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(8)),
              child: Text("Send"),
            ),
          ),
        ]),
      ),
    );
  }
}
