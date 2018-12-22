class ItemGallery {

  ItemGallery({
    this.name,
    this.description,
    this.contentUrl
  });

  final String name, description, contentUrl;

  factory ItemGallery.fromJson(Map value) {
    return ItemGallery(
        name: value['name'],
        description: value['description'],
        contentUrl: value['contentUrl'],
    );
  }
}