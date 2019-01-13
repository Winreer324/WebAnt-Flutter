import 'package:webant_flutter/mysor/item_gallery_list.dart';

abstract class FetchGallery {
  Future<ItemGalleryList> fetchMovies(int pageNumber);
}