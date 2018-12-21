import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './my_strings.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

Future<String> fetchPhotos(http.Client client) async {
  final response =
  await client.get('https://jsonplaceholder.typicode.com/photos');

  // Use the compute function to run parsePhotos in a separate isolate
  return compute(parsePhotos, response.body);
}

// A function that will convert a response body into a List<Photo>
String parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<String>((json) => json);
}


// ignore: must_be_immutable
class NewGalleryPage extends StatelessWidget {

//
  List data = [];
  final bool show=true;
  // ignore: missing_return
  Future<String> makeRequest() async {

    final response = await http
        .get(Uri.encodeFull(MyStrings.newGalleryUrl), headers: {"Accept": "application/json"});
    await refreshGallery();
    print(response.body);
    var extractData = json.decode(response.body);
    data = extractData["data"];

//    setState((){
//      var extractData = json.decode(response.body);
//      data = extractData["data"];
//    }) ;
//    print(response.body);

  }
  var refreshKey = GlobalKey<RefreshIndicatorState>();
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(MyStrings.newPage,style: TextStyle(color: Color(0xff2f1767),fontSize: 30.0),),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshGallery,
        child: FutureBuilder(
          future:   makeRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return ShowImage(data: data);
          },
        ),
      )
    );
  }

  Future<Null> refreshGallery() async {
    refreshKey.currentState?.show(atTop: true);
    await Future.delayed(Duration(milliseconds: 2500));

    return null;
  }
}

class ShowImage extends StatelessWidget {
  final List data;

  ShowImage({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(6.0),
            child: SizedBox(
//            width: 10.0,
//            height: 190.0,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new Popup(data[index])
                      )
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                        image: NetworkImage(MyStrings.connectUrl+data[index]["image"]["contentUrl"],),
                        fit: BoxFit.fitHeight
                    )
                  ),
                ),
              ),
            ),
          );
        },
    );
  }

}

class Popup extends StatelessWidget{
  Popup(this.data);
  final data;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(data["name"]),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 210.0,
          decoration: BoxDecoration(
            color: Color(0xff7c94b6),
            image: DecorationImage(
              image: NetworkImage(MyStrings.connectUrl+data["image"]["contentUrl"],),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: Padding(
            padding: EdgeInsets.only(
                top: 45.0,
                left: 25.0,
                right: 25.0
            ),
            child: Text(
              data["name"],
              style: TextStyle(
                color: Colors.purple,
                fontSize: 24.0
              ),
              textAlign: TextAlign.left,),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: Padding(
            padding: EdgeInsets.only(
                top: 65.0,
                left: 25.0,
                right: 25.0
            ),
            child: Text(
              data["description"],
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 18.0
              ),
              textAlign: TextAlign.left,),
          ),
        ),
      ],
    ),
  );
}