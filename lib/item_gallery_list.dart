import 'package:webant_flutter/item_gallery.dart';

class ItemGalleryList {

  ItemGalleryList(this.urlList, {
    this.contentUrl,
  });
  final int contentUrl;
  final List<ItemGallery> urlList;

  ItemGalleryList.fromMap(Map<String, dynamic> value)
      : contentUrl = value['contentUrl'],

        urlList = new List<ItemGallery>.from(
            value['image'].map((movie) => ItemGallery.fromJson(movie))
        );
}