import 'dart:convert';

// Model für die Pflanze
class PlantWikiModel {
  final String commonName;
  final List<String> scientificName;
  final String cycle;
  final String watering;
  final List<String> sunlight;
  final String originalImageUrl;
  final String thumbnailUrl;

  PlantWikiModel({
    required this.commonName,
    required this.scientificName,
    required this.cycle,
    required this.watering,
    required this.sunlight,
    required this.originalImageUrl,
    required this.thumbnailUrl
  });

  factory PlantWikiModel.fromJson(Map<String, dynamic> json) {
    // Hier wird überprüft, ob die Daten vom Typ 'List' oder 'String' sind
    List<String> parseList(dynamic value) {
      if (value is List) {
        return List<String>.from(value);
      } else if (value is String) {
        return [value];
      } else {
        return ["/"];
      }
    }

    final defaultImage = json['default_image'] ?? {};
    return PlantWikiModel(
      commonName: json['common_name'] ?? 'Unknown',
      scientificName: parseList(json['scientific_name']),
      cycle: json['cycle'] ?? '/',
      watering: json['watering'] ?? '/',
      sunlight: parseList(json['sunlight']),
      originalImageUrl: defaultImage['original_url'] ?? '',
      thumbnailUrl: defaultImage['thumbnail'] ?? '',
    );
  }
}
