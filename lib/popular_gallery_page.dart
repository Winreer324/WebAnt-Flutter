import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webant_flutter/show_image.dart';

import './my_strings.dart';

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

class PopularGallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PopularGalleryPageState();

}

class PopularGalleryPageState extends State<PopularGallery> {

  List data = [];
  final bool show = true;

  Future<List> makeRequest() async {
    final response = await http
        .get(Uri.encodeFull(MyStrings.popularGalleryUrl), headers: {"Accept": "application/json"});

    print(response.body);
    var extractData = json.decode(response.body);
    data = extractData["data"];
//    setState((){
//      var extractdata = json.decode(response.body);
//      data = extractdata["data"];
//    }) ;
//    print(response.body);
//    refreshGallery();
    return data;
  }
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(MyStrings.popularPage,style: TextStyle(color: Color(0xff2f1767),fontSize: 30.0),),
        ),
        body: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshGallery,
          child: FutureBuilder(
            future:   makeRequest(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("${snapshot.error} not connect ");
                return Center(child: Image.asset("assets/not_connect.png"));
              }
              else return ShowImage(data: data);
            },
          ),
        )
    );
  }

  Future<Null> refreshGallery() async {
    refreshKey.currentState?.show();
    await Future.delayed(Duration(milliseconds: 2500));

    return null;
  }
}