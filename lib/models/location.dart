import 'dart:convert';
import 'package:hive_ce/hive.dart';

class LocationModel extends HiveObject {
  int id;
  String country;
  String region;
  String town;
  String address;
  String postal_code;
  String quarter;
  String precision;
  String isoCode;
  bool popular_location;
  CustomCoordinates coordinates;
  String name;

  LocationModel({
    this.id = 0,
    required this.country,
    required this.region,
    required this.town,
    required this.coordinates,
    this.address = '',
    this.postal_code = '0',
    this.quarter = '',
    this.precision = '',
    this.isoCode = '',
    this.name = '',
    this.popular_location = true,
  });

  String get formattedAddress =>
      (country.isEmpty && region.isEmpty && town.isEmpty)
      ? ''
      : '${country.split(' ').join('')}, $region, $town';

  String get display =>
      (region.isEmpty && town.isEmpty) ? '' : '$region $town $precision';

  String get customDisplay =>
      (region.isEmpty && town.isEmpty) ? '' : '$town $name $quarter';
  String get searchDisplay =>
      (region.isEmpty && town.isEmpty) ? '' : '$name $quarter';

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'country': country});
    result.addAll({'region': region});
    result.addAll({'city_name': town});
    result.addAll({'address': '$country $region $town'});
    result.addAll({'postal_code': postal_code});
    result.addAll({'quarter': quarter});
    result.addAll({'precision': precision});
    result.addAll({'popular_location': popular_location});
    result.addAll({'coordinates': coordinates.toMap()});
    result.addAll({'name': name});
    return result;
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? 0,
      country: map['country'] ?? '',
      region: map['region'] ?? '',
      town: map['city_name'] ?? '',
      postal_code: map['postal_code'] ?? '',
      quarter: map['quarter'] ?? '',
      precision: map['precision'] ?? '',
      name: map['name'] ?? '',
      popular_location: map['popular_location'] ?? false,
      coordinates: map['coordinates'] == null
          ? CustomCoordinates(latitude: 0, longitude: 0)
          : CustomCoordinates.fromMap(map['coordinates']),
    );
  }

  // from photonapi
  factory LocationModel.fromPhoton(Map<String, dynamic> photonFeature) {
    final properties = photonFeature['properties'] as Map<String, dynamic>;
    final geometry = photonFeature['geometry'] as Map<String, dynamic>;
    final coordinates = List<double>.from(
      geometry['coordinates'] ?? [0.0, 0.0],
    );

    return LocationModel(
      id: properties['osm_id'] ?? 0,
      country: properties['country'] ?? '',
      region: properties['state'] ?? '',
      town: properties['city'] ?? properties['locality'] ?? '',
      postal_code: properties['postcode'] ?? '',
      quarter: properties['district'] ?? '',
      name: properties['name'] ?? '',
      precision: properties['type'] ?? '',
      isoCode: properties['countrycode'] ?? '',
      popular_location: true, // Assume true for all mapped locations
      coordinates: CustomCoordinates(
        latitude: coordinates.isNotEmpty ? coordinates[1] : 0.0,
        longitude: coordinates.isNotEmpty ? coordinates[0] : 0.0,
      ),
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      LocationModel.fromMap(json);

  factory LocationModel.fromJsonString(String source) =>
      LocationModel.fromMap(json.decode(source));

  LocationModel copyWith({
    int? id,
    String? country,
    String? region,
    String? town,
    String? address,
    String? postal_code,
    String? quarter,
    String? precision,
    String? isoCode,
    bool? popular_location,
    CustomCoordinates? coordinates,
    String? name,
  }) {
    return LocationModel(
      id: id ?? this.id,
      country: country ?? this.country,
      region: region ?? this.region,
      town: town ?? this.town,
      address: address ?? this.address,
      postal_code: postal_code ?? this.postal_code,
      quarter: quarter ?? this.quarter,
      precision: precision ?? this.precision,
      isoCode: isoCode ?? this.isoCode,
      popular_location: popular_location ?? this.popular_location,
      coordinates: coordinates ?? this.coordinates,
      name: name ?? this.name,
    );
  }
}

class CustomCoordinates extends HiveObject {
  double latitude;

  double longitude;

  CustomCoordinates({required this.latitude, required this.longitude});

  CustomCoordinates copyWith({double? latitude, double? longitude}) {
    return CustomCoordinates(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  factory CustomCoordinates.fromMap(Map<String, dynamic> map) {
    return CustomCoordinates(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => json.encode(toMap());

  factory CustomCoordinates.fromJson(Map<String, dynamic> json) =>
      CustomCoordinates.fromMap(json);

  factory CustomCoordinates.fromJsonString(String source) =>
      CustomCoordinates.fromMap(json.decode(source));
}
