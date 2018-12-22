import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './my_strings.dart';

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
              image: CachedNetworkImageProvider(MyStrings.connectUrl+data["image"]["contentUrl"],),
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