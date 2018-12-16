import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webant_flutter/item_gallery.dart';

class ParseJson{
  List<ItemGallery> data = [];
  getList(){
    return data;
  }
   parseJson(String str) async {
     http.Response response = await http.get(str);
     print(response.body);

     var parseJson = json.decode(response.body);


     var list = List<ItemGallery>();
     parseJson.forEach((String key,dynamic val){
//       var record = ItemGallery(
//           urlImg: parseJson["contentUrl"],
//           name: parseJson['name'],
//           description: parseJson["description"]);;
//       list.add(record);
     });
     data = list;
     print("list parseJson = "+list.toString());
     print("data parseJson = "+data.toString());
   }

}