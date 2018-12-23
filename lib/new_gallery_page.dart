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

  return compute(parsePhotos, response.body);
}

String parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<String>((json) => json);
}
class NewGallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewGalleryPageState();
}

class NewGalleryPageState extends State<NewGallery> {
  ScrollController _scrollController = ScrollController();
  String lol = MyStrings.newGalleryUrl;
//
  List data = [];
  bool show = true;
  int countP = 1;

  @override
  void initState(){
    super.initState();
    _scrollController.addListener((){
//      print(_scrollController.position.pixels);
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(countP<2){
          moreImage();
//            show=false;
          countP++;
        }
      }
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
//
  bool checkConnect(AsyncSnapshot snapshot){
    bool check = false;
    if (snapshot.hasError){
      print("${snapshot.error} ${MyStrings.newPage} not connect ");check = false;
    }
    if (snapshot.hasData){
      print("${snapshot.hasData} ${MyStrings.newPage} good connect ");check = true;
    }
    return check;
  }

  Future<Null> refreshGallery() async {
    await Future.delayed(Duration(milliseconds: 2500));

    return null;
  }

  Future<List> makeRequest(String url) async {
    final response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print("url = $url");
    if(response.statusCode == 200){

      var extractData = json.decode(response.body)["data"];
      for(var val in extractData){
        print(val);
        this.data.add(val);
      }

    }
    else {throw Exception("Failed to load json ${MyStrings.newPage}");}

    return data;
  }

  moreImage()  {
//    final response = await http
//        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
//
//      print("more = "+response.body);
//      var extractData = json.decode(response.body)["data"];
//
//      print("before data = ${data.toString()}");
//      print("extractData = ${extractData.toString()}");

    setState(() {
//        for(var val in data){
//          print("data $val");
////          data.add(val);
//        }
//      if(countP==2){lol = MyStrings.newGalleryUrlTwoPage;}
//      if(countP==3){lol = MyStrings.newGalleryUrlThreePage;}
      lol = MyStrings.newGalleryUrlThreePage;
    });
//      print("after data = ${data.toString()}");
//      print(data.toString());

    ShowImage(data: data,scrollController: _scrollController,);
    print(data.length);
  }
//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(MyStrings.newPage,
          style: TextStyle(color: Color(0xff2f1767), fontSize: 30.0),),
      ),
      body: RefreshIndicator(
        onRefresh: refreshGallery,
        child: FutureBuilder(
          future: makeRequest(lol),
          builder: (context, snapshot) {
//          if (!checkConnect(snapshot)) {
            if (snapshot.hasError) {
              return Center(child: Image.asset("assets/not_connect.png"));
            }
            else return ShowImage(data: data,scrollController: _scrollController,);
          },
        ),
      ),
    );
  }
}