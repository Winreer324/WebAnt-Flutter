import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:webant_flutter/my_strings.dart';
import 'package:webant_flutter/popup.dart';

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