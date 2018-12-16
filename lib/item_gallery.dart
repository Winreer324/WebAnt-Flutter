class ItemGallery {

  final String urlImg;
  final String name;
  final String description;

  ItemGallery(this.urlImg, this.name,this.description);


  ItemGallery.fromJson(Map<String, dynamic> json)
      : urlImg = json['contentUrl'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() =>
      {
        'contentUrl': urlImg,
        'name': name,
        'description': description,
      };
}