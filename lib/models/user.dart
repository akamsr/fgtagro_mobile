import 'dart:convert';
import 'package:hive_ce/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
enum UserRole {
  @HiveField(0)
  shopper,
  @HiveField(1)
  businessStaff,
  @HiveField(2)
  business,
  @HiveField(3)
  deliveryPartnerAdmin,
  @HiveField(4)
  dispatcher,
  @HiveField(5)
  deliveryAgent,
  @HiveField(6)
  deliveryAccountant,
  @HiveField(7)
  buzmeEmployee,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.shopper:
        return "Shopper";
      case UserRole.businessStaff:
        return "Business Staff";
      case UserRole.business:
        return "Business";
      case UserRole.deliveryPartnerAdmin:
        return "Delivery Partner Admin";
      case UserRole.dispatcher:
        return "Dispatcher";
      case UserRole.deliveryAgent:
        return "Delivery Agent";
      case UserRole.deliveryAccountant:
        return "Delivery Accountant";
      case UserRole.buzmeEmployee:
        return "Buzme Employee";
    }
  }

  static UserRole? fromString(String role) {
    switch (role.toLowerCase()) {
      case "shopper":
        return UserRole.shopper;
      case "business staff":
        return UserRole.businessStaff;
      case "business":
        return UserRole.business;
      case "delivery partner admin":
        return UserRole.deliveryPartnerAdmin;
      case "dispatcher":
        return UserRole.dispatcher;
      case "delivery agent":
        return UserRole.deliveryAgent;
      case "delivery accountant":
        return UserRole.deliveryAccountant;
      case "buzme employee":
        return UserRole.buzmeEmployee;
      default:
        return null;
    }
  }
}

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? expireIn;
  @HiveField(2)
  String uid;
  @HiveField(3)
  String? fullNames;
  @HiveField(4)
  List<dynamic>? roles;
  @HiveField(5)
  List<dynamic>? interest;
  @HiveField(6)
  String? email;
  @HiveField(7)
  String? phoneNumber;
  @HiveField(8)
  String? photoUrl;
  @HiveField(9)
  String provider;
  @HiveField(10)
  String? token;
  @HiveField(11)
  String? deviceToken;
  @HiveField(12)
  String regionCityAdress;
  @HiveField(13)
  String? createdAt;
  @HiveField(14)
  String? updatedAt;
  @HiveField(15)
  int? agentId;
  @HiveField(16)
  String? ambassadorId;
  @HiveField(17)
  String deviceId;
  @HiveField(18)
  String refreshToken;
  @HiveField(19)
  String password;
  @HiveField(20)
  UserRole? role;
  @HiveField(21)
  bool is_online;
  @HiveField(22)
  DateTime? last_seen;

  String get firstName => fullNames?.split(' ').first ?? '';
  String get lastName => (fullNames?.split(' ').length ?? 0) > 1 ? fullNames!.split(' ').sublist(1).join(' ') : '';

  UserModel({
    this.uid = '',
    this.id,
    this.expireIn,
    this.fullNames,
    this.roles = const [],
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.provider = '',
    this.token,
    this.regionCityAdress = '',
    this.interest = const [],
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.ambassadorId,
    this.deviceId = '',
    this.refreshToken = '',
    this.password = '',
    this.agentId,
    this.role,
    this.is_online = false,
    this.last_seen,
  });

  static UserModel empty = UserModel(uid: '');

  factory UserModel.fromJson2(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as int,
      expireIn:
          int.tryParse(json["expireIn"].toString()) ??
          json['expireIn'].toInt() ??
          0,
      uid: json["uid"] as String,
      fullNames: json["fullNames"] as String,
      roles: List<dynamic>.from(json["Roles"] ?? []),
      role: UserRoleExtension.fromString(json['role'] ?? ''),
      email: json["email"] as String,
      is_online: json["is_online"] ?? false,
      last_seen: DateTime.tryParse(json["last_seen"] ?? ""),
      password: json["password"] ?? '',
      regionCityAdress: json['regionCityAdress'] ?? '',
      phoneNumber: json["phoneNumber"] as String,
      photoUrl: json["photoUrl"] as String?,
      provider: json["provider"] ?? '',
      token: json["token"] as String?,
      createdAt: json["createdAt"] as String?,
      deviceToken: json["deviceToken"] as String?,
      deviceId: json["deviceId"] ?? '',
      refreshToken: json["refreshToken"] ?? '',
      updatedAt: json["updatedAt"] as String?,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, expireIn: $expireIn, uid: $uid, fullNames: $fullNames, interest: $interest, email: $email, phoneNumber: $phoneNumber, photoUrl: $photoUrl, provider: $provider, token: $token, regionCityAdress: $regionCityAdress, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'uid': uid});
    result.addAll({'fullNames': fullNames});
    result.addAll({'roles': roles});
    result.addAll({'email': email});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'photoUrl': photoUrl});
    result.addAll({'provider': provider});
    result.addAll({'password': password});
    result.addAll({'token': token});
    result.addAll({'is_online': is_online});
    result.addAll({'last_seen': last_seen?.toIso8601String()});
    result.addAll({'deviceToken': deviceToken});
    result.addAll({'regionCityAdress': regionCityAdress});
    result.addAll({'createdAt': createdAt});
    result.addAll({'updatedAt': updatedAt});
    result.addAll({'ambassadorId': ambassadorId});
    result.addAll({'deviceId': deviceId});
    result.addAll({'refreshToken': refreshToken});

    return result;
  }

  Map<String, dynamic> toMapCall() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'fullNames': fullNames});
    result.addAll({'roles': roles});
    result.addAll({'photoUrl': photoUrl});
    result.addAll({'provider': provider});
    result.addAll({'deviceToken': deviceToken});
    result.addAll({'regionCityAdress': regionCityAdress});
    result.addAll({'ambassadorId': ambassadorId});
    result.addAll({'deviceId': deviceId});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final rawId = map['id'];
    int? parsedId;
    String parsedUid = map['uid'] ?? '';
    
    if (rawId is int) {
      parsedId = rawId;
    } else if (rawId is String) {
      if (int.tryParse(rawId) != null) {
        parsedId = int.tryParse(rawId);
      } else {
        parsedUid = rawId;
      }
    }

    final String firstName = map['first_name'] ?? '';
    final String lastName = map['last_name'] ?? '';
    String fullName = map['fullNames'] ?? '';
    if (fullName.isEmpty && (firstName.isNotEmpty || lastName.isNotEmpty)) {
      fullName = '$firstName $lastName'.trim();
    }

    return UserModel(
      id: parsedId ?? 0,
      uid: parsedUid,
      fullNames: fullName,
      roles: map['Roles'] ?? [],
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',

      photoUrl: map['photoUrl'] ?? '',
      role: UserRoleExtension.fromString(map['role'] ?? ''),
      provider: map['provider'] ?? '',
      token: map['token'] ?? '',
      deviceToken: map["deviceToken"] ?? '',
      regionCityAdress: map['regionCityAdress'] ?? '',
      password: map["password"] ?? '',
      refreshToken: map["refreshToken"] ?? '',
      agentId: map['agentId'],
      deviceId: map['deviceId'] ?? '',
      createdAt: map['createdAt'] ?? DateTime.now().toString(),
      updatedAt: map['updatedAt'] ?? DateTime.now().toString(),
    );
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => json.encode(toMap());

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel.fromMap(json);

  factory UserModel.fromJsonString(String source) =>
      UserModel.fromMap(json.decode(source));

  factory UserModel.fromLocalMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,

      uid: map['uid'] ?? '',
      fullNames: map['fullNames'] ?? '',
      roles: map['Roles'] ?? [],
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      provider: map['provider'] ?? '',
      role: UserRoleExtension.fromString(map['role'] ?? ''),
      token: map['token'] ?? '',
      deviceToken: map["deviceToken"] ?? '',
      regionCityAdress: map['regionCityAdress'] ?? '',
      refreshToken: map["refreshToken"] ?? '',
      agentId: map['agentId'],
      deviceId: map['deviceId'] ?? '',
      createdAt: map['createdAt'] ?? DateTime.now().toString(),
      updatedAt: map['updatedAt'] ?? DateTime.now().toString(),
    );
  }

  UserModel copyWith({
    int? id,
    int? expireIn,
    String? uid,
    String? fullNames,
    List<dynamic>? roles,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? provider,
    String? token,
    String? regionCityAdress,
    String? createdAt,
    String? updatedAt,
    String? deviceToken,
    String? deviceId,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      expireIn: expireIn ?? this.expireIn,
      uid: uid ?? this.uid,
      fullNames: fullNames ?? this.fullNames,
      interest: interest ?? this.interest,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      provider: provider ?? this.provider,
      token: token ?? this.token,
      regionCityAdress: regionCityAdress ?? this.regionCityAdress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceToken: deviceToken ?? this.deviceToken,
      deviceId: deviceId ?? this.deviceId,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
