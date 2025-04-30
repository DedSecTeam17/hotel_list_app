class HotelCategory {
  final String id;
  final String name;

  HotelCategory({required this.id, required this.name});
}

class Hotel {
  final String name;
  final String city;
  final String location;
  final String type;
  final List<String> imageUrls;
  final List<HotelCategory> categories;
  final String? overviewText;
  final String? openingHours;
  final Map<String, dynamic>? coordinates;
  final List<HotelThingToDo> thingsToDo;

  Hotel({
    required this.name,
    required this.city,
    required this.location,
    required this.type,
    required this.imageUrls,
    required this.categories,
    this.overviewText,
    this.openingHours,
    this.coordinates,
    required this.thingsToDo,
  });
}

class HotelThingToDo {
  final String title;
  final String? subtitle;
  final String? badge;
  final List<List<HotelTextContent>>? content;
  final List<HotelImageItem>? items;

  HotelThingToDo({
    required this.title,
    this.subtitle,
    this.badge,
    this.content,
    this.items,
  });
}

class HotelTextContent {
  final String text;

  HotelTextContent({required this.text});
}

class HotelImageItem {
  final String imageUrl;
  final String? title;

  HotelImageItem({required this.imageUrl, this.title});
}
