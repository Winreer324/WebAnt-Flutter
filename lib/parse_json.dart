import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:webant_flutter/fetch_gallery.dart';
import 'package:webant_flutter/item_gallery_list.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import './my_strings.dart';

class MovieProdRepository implements FetchGallery {
  @override
  Future<ItemGalleryList> fetchMovies(int pageNumber) async {
    http.Response response = await http.get(MyStrings.newGalleryUrl);
    return compute(parseItem, response.body);
  }
}
ItemGalleryList parseItem(String responseBody) {
  final Map moviesMap = JsonCodec().decode(responseBody);
  print(moviesMap);
  ItemGalleryList itemData = ItemGalleryList.fromMap(moviesMap);
  if (itemData == null) {
    throw new Exception("An error occurred : [ Status Code = ]");
  }
  return itemData;
}