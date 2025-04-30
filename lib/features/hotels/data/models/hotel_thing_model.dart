class HotelTextContentModel {
  final String text;

  HotelTextContentModel({required this.text});

  factory HotelTextContentModel.fromJson(Map<String, dynamic> json) {
    return HotelTextContentModel(text: json['text']);
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}

class HotelImageItemModel {
  final String imageUrl;
  final String? title;

  HotelImageItemModel({required this.imageUrl, this.title});

  factory HotelImageItemModel.fromJson(Map<String, dynamic> json) {
    final imageData = json['image'];
    return HotelImageItemModel(
      imageUrl: imageData != null && imageData['url'] != null
          ? imageData['url']
          : '', // fallback or placeholder URL
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': {'url': imageUrl},
      'title': title,
    };
  }
}

class HotelThingToDoModel {
  final String title;
  final String? subtitle;
  final String? badge;
  final List<List<HotelTextContentModel>>? content;
  final List<HotelImageItemModel>? items;

  HotelThingToDoModel({
    required this.title,
    this.subtitle,
    this.badge,
    this.content,
    this.items,
  });

  factory HotelThingToDoModel.fromJson(Map<String, dynamic> json) {
    return HotelThingToDoModel(
      title: json['title'],
      subtitle: json['subtitle'],
      badge: json['badge'],
      content: json['content'] != null
          ? (json['content'] as List)
              .map<List<HotelTextContentModel>>((group) => (group as List)
                  .map((item) => HotelTextContentModel.fromJson(item))
                  .toList())
              .toList()
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => HotelImageItemModel.fromJson(e))
              .where((item) => item.imageUrl.isNotEmpty)
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'badge': badge,
      'content': content
          ?.map((group) => group.map((item) => item.toJson()).toList())
          .toList(),
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }
}
