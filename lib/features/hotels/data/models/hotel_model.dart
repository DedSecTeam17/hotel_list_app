import 'package:hotel_list_app/features/hotels/data/models/hotel_thing_model.dart';

class HotelCategoryModel {
  final String id;
  final String name;

  HotelCategoryModel({required this.id, required this.name});

  factory HotelCategoryModel.fromJson(Map<String, dynamic> json) {
    return HotelCategoryModel(
      id: json['id'],
      name: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'category': name};
  }
}

class HotelModel {
  final String name;
  final String city;
  final String location;
  final String type;
  final List<String> imageUrls;
  final List<HotelCategoryModel> categories;
  final String? openingHours;
  final String? overviewText;
  final List<HotelThingToDoModel> thingsToDo;
  final Map<String, dynamic>? coordinates;

  HotelModel({
    required this.name,
    required this.city,
    required this.location,
    required this.type,
    required this.imageUrls,
    required this.categories,
    required this.openingHours,
    required this.overviewText,
    required this.thingsToDo,
    required this.coordinates,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      imageUrls:
          (json['images'] as List).map((e) => e['url'] as String).toList(),
      categories: (json['categories'] as List)
          .map((e) => HotelCategoryModel.fromJson(e))
          .toList(),
      openingHours: (json['openingHours'] as Map?)?.isNotEmpty == true
          ? json['openingHours'].toString()
          : null,
      overviewText: json['overviewText'] != null
          ? (json['overviewText'] as List).map((e) => e['text']).join('\n\n')
          : null,
      thingsToDo: json['thingsToDo'] != null
          ? (json['thingsToDo'] as List)
              .map((e) => HotelThingToDoModel.fromJson(e))
              .toList()
          : [],
      coordinates: json['coordinates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
      'location': location,
      'type': type,
      'images': imageUrls.map((url) => {'url': url}).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
      'openingHours': openingHours != null ? openingHours : null,
      'overviewText': overviewText != null
          ? overviewText!.split('\n\n').map((text) => {'text': text}).toList()
          : null,
      'thingsToDo': thingsToDo.map((thing) => thing.toJson()).toList(),
      'coordinates': coordinates,
    };
  }
}
