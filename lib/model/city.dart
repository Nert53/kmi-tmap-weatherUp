
const String tableCity = 'city';

class CityFields {
  static final List<String> values = [
    id,
    name,
    country,
    cityCode,
    latitude,
    longitude,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String country = 'country';
  static const String cityCode = 'cityCode';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
}

class City {
  final String id;
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });


  Map<String, Object?> toJson() => {
        CityFields.id: id,
        CityFields.name: name,
        CityFields.country: country,
        CityFields.latitude: latitude,
        CityFields.longitude: longitude,
      };

  static City fromJson(Map<String, Object?> json) => City(
        id: json[CityFields.id] as String,
        name: json[CityFields.name] as String,
        country: json[CityFields.country] as String,
        latitude: json[CityFields.latitude] as double,
        longitude: json[CityFields.longitude] as double,
      );    

  City copy({
    String? id,
    String? name,
    String? country,
    double? latitude,
    double? longitude,
  }) =>
      City(
        id: id ?? this.id,
        name: name ?? this.name,
        country: country ?? this.country,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}
