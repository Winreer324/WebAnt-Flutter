import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



//class Photo {
//  final String name;
//  final String description;
//  final String contentUrl;
//
//  Photo({this.name, this.description, this.contentUrl});
//
//  factory Photo.fromJson(Map<String, dynamic> json) {
//
//    return Photo(
//      name: json['name'] as String,
//      description: json['description'] as String,
//      contentUrl: data["image"]['contentUrl'] as String,
//    );
//  }
//}
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



class MyGalleryPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MyGalleryState();

}

class MyGalleryState extends State<MyGalleryPage>{
  final String url = "http://gallery.dev.webant.ru/api/photos";
  final String connectUrl = "http://gallery.dev.webant.ru/media/";

  List data = [];
  final bool show=true;
  Future<String> makeRequest() async {
    final response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print(response.body);

    setState((){
      var extractData = json.decode(response.body);
      data = extractData["data"];
    }) ;
    print(response.body);
  }

//  @override
//  void initState(){
//    this.makeRequest();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Gallery"),
      ),
      body: FutureBuilder(
        future:   makeRequest(),
        builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return ShowImage(data: data);
//          snapshot.hasData
//            ? ShowImage(data: data)
//            : Center(child: CircularProgressIndicator() );
        },
      ),
    );
  }

}
//todo сделать нормальный вывод
// //todo мб переделать как тут https://flutter.io/docs/cookbook/networking/background-parsing
// contact list пример
// todo исправить и понять почему миллион запросов отправляется

class ShowImage extends StatelessWidget {
  final List data;
  final String url = "http://gallery.dev.webant.ru/api/photos";
  final String connectUrl = "http://gallery.dev.webant.ru/media/";

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
            padding: EdgeInsets.all(2.0),
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0,color: Colors.blue),
              ),
              child: Image.network(
                connectUrl+data[index]["image"]["contentUrl"],
                width: 10.0,
                height: 10.0,
              ),
            )

        );
      },
    );
  }
}