import 'package:hive_ce/hive.dart';

part 'equipment.g.dart';

@HiveType(typeId: 30)
class EquipmentModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String type; // Tractor, Harvester, etc.
  @HiveField(2)
  final String brand;
  @HiveField(3)
  final String model;
  @HiveField(4)
  final int? yearOfManufacture;
  @HiveField(5)
  final double? enginePower;
  @HiveField(6)
  final String? enginePowerUnit; // HP or kW
  @HiveField(7)
  final String? condition; // Excellent, Good, etc.
  @HiveField(8)
  final Map<String, String> photoSlots; // front, side, dashboard, engine
  @HiveField(9)
  final List<String> additionalPhotos;
  @HiveField(10)
  final List<EquipmentDocument> documents;
  @HiveField(11)
  final double dailyRate;
  @HiveField(12)
  final double? hourlyRate;
  @HiveField(13)
  final double? halfDayRate;
  @HiveField(14)
  final double? weeklyRate;
  @HiveField(15)
  final double? monthlyRate;
  @HiveField(16)
  final double securityDeposit;
  @HiveField(17)
  final String fuelPolicy;
  @HiveField(18)
  final List<DateTime> unavailableDates;
  @HiveField(19)
  final String noticePeriod;
  @HiveField(20)
  final String minDuration;
  @HiveField(21)
  final String maxDuration;
  @HiveField(22)
  final String geoAreaType; // RADIUS or CUSTOM_ZONE
  @HiveField(23)
  final double? geoAreaRadius;
  @HiveField(24)
  final List<Map<String, double>>? geoAreaPolygon;
  @HiveField(25)
  final String experienceLevel;
  @HiveField(26)
  final List<String> permittedUses;
  @HiveField(27)
  final String? restrictions;
  @HiveField(28)
  final bool tenantInsuranceRequired;
  @HiveField(29)
  final String status; // PUBLISHED, EN_VALIDATION, DRAFT, SUSPENDED
  @HiveField(30)
  final bool isAvailable;

  EquipmentModel({
    required this.id,
    required this.type,
    required this.brand,
    required this.model,
    this.yearOfManufacture,
    this.enginePower,
    this.enginePowerUnit,
    this.condition,
    this.photoSlots = const {},
    this.additionalPhotos = const [],
    this.documents = const [],
    required this.dailyRate,
    this.hourlyRate,
    this.halfDayRate,
    this.weeklyRate,
    this.monthlyRate,
    required this.securityDeposit,
    required this.fuelPolicy,
    this.unavailableDates = const [],
    this.noticePeriod = '24h',
    this.minDuration = '1 day',
    this.maxDuration = 'No limit',
    this.geoAreaType = 'RADIUS',
    this.geoAreaRadius,
    this.geoAreaPolygon,
    this.experienceLevel = 'None',
    this.permittedUses = const [],
    this.restrictions,
    this.tenantInsuranceRequired = false,
    this.status = 'DRAFT',
    this.isAvailable = true,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      yearOfManufacture: json['yearOfManufacture'],
      enginePower: (json['enginePower'] ?? 0).toDouble(),
      enginePowerUnit: json['enginePowerUnit'],
      condition: json['condition'],
      photoSlots: Map<String, String>.from(json['photoSlots'] ?? {}),
      additionalPhotos: List<String>.from(json['additionalPhotos'] ?? []),
      documents: (json['documents'] as List? ?? [])
          .map((d) => EquipmentDocument.fromJson(d))
          .toList(),
      dailyRate: (json['dailyRate'] ?? 0).toDouble(),
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble(),
      halfDayRate: (json['halfDayRate'] as num?)?.toDouble(),
      weeklyRate: (json['weeklyRate'] as num?)?.toDouble(),
      monthlyRate: (json['monthlyRate'] as num?)?.toDouble(),
      securityDeposit: (json['securityDeposit'] ?? 0).toDouble(),
      fuelPolicy: json['fuelPolicy'] ?? 'Full-to-full',
      unavailableDates: (json['unavailableDates'] as List? ?? [])
          .map((d) => DateTime.parse(d))
          .toList(),
      noticePeriod: json['noticePeriod'] ?? '24h',
      minDuration: json['minDuration'] ?? '1 day',
      maxDuration: json['maxDuration'] ?? 'No limit',
      geoAreaType: json['geoAreaType'] ?? 'RADIUS',
      geoAreaRadius: (json['geoAreaRadius'] as num?)?.toDouble(),
      geoAreaPolygon: (json['geoAreaPolygon'] as List?)
          ?.map((p) => Map<String, double>.from(p))
          .toList(),
      experienceLevel: json['experienceLevel'] ?? 'None',
      permittedUses: List<String>.from(json['permittedUses'] ?? []),
      restrictions: json['restrictions'],
      tenantInsuranceRequired: json['tenantInsuranceRequired'] ?? false,
      status: json['status'] ?? 'DRAFT',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'brand': brand,
      'model': model,
      'yearOfManufacture': yearOfManufacture,
      'enginePower': enginePower,
      'enginePowerUnit': enginePowerUnit,
      'condition': condition,
      'photoSlots': photoSlots,
      'additionalPhotos': additionalPhotos,
      'documents': documents.map((d) => d.toJson()).toList(),
      'dailyRate': dailyRate,
      'hourlyRate': hourlyRate,
      'halfDayRate': halfDayRate,
      'weeklyRate': weeklyRate,
      'monthlyRate': monthlyRate,
      'securityDeposit': securityDeposit,
      'fuelPolicy': fuelPolicy,
      'unavailableDates':
          unavailableDates.map((d) => d.toIso8601String()).toList(),
      'noticePeriod': noticePeriod,
      'minDuration': minDuration,
      'maxDuration': maxDuration,
      'geoAreaType': geoAreaType,
      'geoAreaRadius': geoAreaRadius,
      'geoAreaPolygon': geoAreaPolygon,
      'experienceLevel': experienceLevel,
      'permittedUses': permittedUses,
      'restrictions': restrictions,
      'tenantInsuranceRequired': tenantInsuranceRequired,
      'status': status,
      'isAvailable': isAvailable,
    };
  }
}

@HiveType(typeId: 31)
class EquipmentDocument {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String url;
  @HiveField(2)
  final DateTime uploadDate;
  @HiveField(3)
  final String status; // VALID, EXPIRED, PENDING
  @HiveField(4)
  final DateTime? expiryDate;

  EquipmentDocument({
    required this.name,
    required this.url,
    required this.uploadDate,
    this.status = 'PENDING',
    this.expiryDate,
  });

  factory EquipmentDocument.fromJson(Map<String, dynamic> json) {
    return EquipmentDocument(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      uploadDate: DateTime.parse(json['uploadDate'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'PENDING',
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'uploadDate': uploadDate.toIso8601String(),
      'status': status,
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }
}
