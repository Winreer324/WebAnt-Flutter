import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webant_flutter/item_gallery_list.dart';
import 'package:webant_flutter/movie_status.dart';
import 'package:webant_flutter/popup.dart';

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

  MovieLoadMoreStatus loadMoreStatus = MovieLoadMoreStatus.STABLE;
  final ScrollController scrollController = new ScrollController();
  static const String IMAGE_BASE_URL = "http://image.tmdb.org/t/p/w185";
  List<ItemGalleryList> listItem;
  int currentPageNumber;
  CancelableOperation movieOperation;
//
  List data = [];
  final bool show = true;


  Future<List> makeRequest(String url) async {
    final response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    print(response.body);
    var extractData = json.decode(response.body);
    data = extractData["data"];
    return data;
  }

 @override
  void initState() {
    moreImage("http://gallery.dev.webant.ru/api/photos?new=true&page=2&limit=6");
    super.initState();
    ShowImage(data: data);
  }

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
          future: makeRequest(MyStrings.newGalleryUrl),
          builder: (context, snapshot) {
            if (snapshot.hasError){
              print("${snapshot.error} not connect ");
              return Center(child: Image.asset("assets/not_connect.png"));}
              else return ShowImage(data: data);
          },
        ),
      ),
    );
  }


  Future<Null> refreshGallery() async {
    await Future.delayed(Duration(milliseconds: 2500));

    return null;
  }

  Future<List> moreImage(String url) async {
    final response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print(response.body);
    var extractData = json.decode(response.body);
    data = extractData["data"];
    return data;
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
                        image: CachedNetworkImageProvider(MyStrings.connectUrl+data[index]["image"]["contentUrl"],),
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