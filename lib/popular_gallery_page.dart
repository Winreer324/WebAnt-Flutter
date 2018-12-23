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

class PopularGallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PopularGalleryPageState();

}

class PopularGalleryPageState extends State<PopularGallery> {
  ScrollController _scrollController = ScrollController();
  String connectUrl = MyStrings.popularGalleryUrl;

  List data = [];
  bool show = true;
  int countP = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (countP < 2) {
          moreImage();
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

  bool checkConnect(AsyncSnapshot snapshot) {
    bool check = false;
    if (snapshot.hasError) {
      print("${snapshot.error} ${MyStrings.popularPage} not connect ");
      check = false;
    }
    if (snapshot.hasData) {
      print("${snapshot.hasData} ${MyStrings.popularPage} good connect ");
      check = true;
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
    if (response.statusCode == 200) {
      var extractData = json.decode(response.body)["data"];
      for (var val in extractData) {
        print(val);
        this.data.add(val);
      }
    }
    else {
      throw Exception("Failed to load json ${MyStrings.popularPage}");
    }

    return data;
  }

  moreImage() {
    setState(() {
      connectUrl = MyStrings.popularGalleryUrlThreePage;
    });

    ShowImage(data: data, scrollController: _scrollController,);
    print(data.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(MyStrings.popularPage,
          style: TextStyle(color: Color(0xff2f1767), fontSize: 30.0),),
      ),
      body: RefreshIndicator(
        onRefresh: refreshGallery,
        child: FutureBuilder(
          future: makeRequest(connectUrl),
          builder: (context, snapshot) {
//            if (!checkConnect(snapshot)) {
            if (snapshot.hasError) {
              return Center(child: Image.asset("assets/not_connect.png"));
            }  else return ShowImage(data: data, scrollController: _scrollController,);
          },
        ),
      ),
    );
  }
}