import 'package:webant_flutter/item_gallery_list.dart';

abstract class FetchGallery {
  Future<ItemGalleryList> fetchMovies(int pageNumber);
}