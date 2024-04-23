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
  final int id;
  final String name;
  final String country;
  final String? cityCode;
  final double latitude;
  final double longitude;

  City({
    required this.id,
    required this.name,
    required this.country,
    this.cityCode,
    required this.latitude,
    required this.longitude,
  });

  Map<String, Object?> toJson() => {
        CityFields.id: id,
        CityFields.name: name,
        CityFields.country: country,
        CityFields.cityCode: cityCode,
        CityFields.latitude: latitude,
        CityFields.longitude: longitude,
      };

  static City fromJson(Map<String, Object?> json) => City(
        id: json[CityFields.id] as int,
        name: json[CityFields.name] as String,
        country: json[CityFields.country] as String,
        cityCode: json[CityFields.cityCode] as String,
        latitude: json[CityFields.latitude] as double,
        longitude: json[CityFields.longitude] as double,
      );    

  City copy({
    int? id,
    String? name,
    String? country,
    String? cityCode,
    double? latitude,
    double? longitude,
  }) =>
      City(
        id: id ?? this.id,
        name: name ?? this.name,
        country: country ?? this.country,
        cityCode: cityCode ?? this.cityCode,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}
