import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:vdsadmin/models/firebase.service.dart';

class CategoryCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const CategoryCard({Key? key, required this.data}) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.data['icon'],
                height: 20,
                width: 50,
              ),
              // Image.network(
              //   widget.data['icon'],
              //   height: 20,
              //   width: 50,
              // ),
              Text(
                '${widget.data['name']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: widget.data['image'],
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.3,
          fit: BoxFit.cover,
        ),
        // Image.network(
        //   widget.data['image'],
        //   height: MediaQuery.of(context).size.height * 0.1,
        //   width: MediaQuery.of(context).size.width * 0.3,
        //   fit: BoxFit.cover,
        // ),
        IconButton(
          icon: Icon(Icons.delete_outline_rounded),
          onPressed: () {
            deleteCategory('${widget.data['name']}');
          },
        ),
        // Expanded(
        //   child: ListView.builder(
        //     // shrinkWrap: true,
        //     itemCount:
        //         widget.data['tags'] != null ? widget.data['tags'].length : 0,
        //     itemBuilder: (_, i) => Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Expanded(
        //               child: Image.network(
        //                 widget.data['tags'][i]['image'],
        //                 width: MediaQuery.of(context).size.width * 0.09,
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.only(left: 2.0),
        //               child: Text(widget.data['tags'][i]['name'].toString(),
        //                   style: const TextStyle(
        //                       fontSize: 14,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.black)),
        //             ),
        //             IconButton(
        //                 icon: Icon(Icons.delete_outline_rounded),
        //                 tooltip: "delete item",
        //                 iconSize: 20,
        //                 onPressed: () {}),
        //           ],
        //         ),
        //         Text("tag :$i"),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  deleteCategory(String name) {
    showDialog(
        context: context,
        builder: (
          context,
        ) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 8),
                        Center(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                  "Are you sure do you want to delete ${name}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87))),
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(left: 6, right: 6),
                            margin: EdgeInsets.all(6),
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                gradient: const LinearGradient(colors: [
                                  Color.fromRGBO(116, 116, 191, 1.0),
                                  Color.fromRGBO(52, 138, 199, 1.0)
                                ]),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.transparent, width: 0)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  highlightColor:
                                      Theme.of(context).highlightColor,
                                  splashColor: Theme.of(context).splashColor,
                                  child: const Center(
                                    child: Text(
                                      "delete",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  onTap: () {
                                    InsertDatainFirebase().DeleteCategory(name);
                                    Navigator.of(context).pop();
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }));
        });
  }
}
