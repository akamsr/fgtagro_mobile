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

  @HiveField(23)
  String? slug;
  @HiveField(24)
  String? passwordHash;
  @HiveField(25)
  String? firstNameField;
  @HiveField(26)
  String? lastNameField;
  @HiveField(27)
  String? avatarUrl;
  @HiveField(28)
  double? gpsLatitude;
  @HiveField(29)
  double? gpsLongitude;
  @HiveField(30)
  bool? emailVerified;
  @HiveField(31)
  bool? phoneVerified;
  @HiveField(32)
  String? pushToken;
  @HiveField(33)
  DateTime? lockedUntil;
  @HiveField(34)
  String? language;
  @HiveField(35)
  String? timezone;
  @HiveField(36)
  String? status;

  String get firstName {
    if (firstNameField != null && firstNameField!.isNotEmpty) {
      return firstNameField!;
    }
    return fullNames?.split(' ').first ?? '';
  }

  String get lastName {
    if (lastNameField != null && lastNameField!.isNotEmpty) {
      return lastNameField!;
    }
    return (fullNames?.split(' ').length ?? 0) > 1 
        ? fullNames!.split(' ').sublist(1).join(' ') 
        : '';
  }

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
    this.slug,
    this.passwordHash,
    this.firstNameField,
    this.lastNameField,
    this.avatarUrl,
    this.gpsLatitude,
    this.gpsLongitude,
    this.emailVerified,
    this.phoneVerified,
    this.pushToken,
    this.lockedUntil,
    this.language,
    this.timezone,
    this.status,
  });

  static UserModel empty = UserModel(uid: '');

  factory UserModel.fromJson2(Map<String, dynamic> json) {
    final String fName = json["first_name"] ?? json["firstName"] ?? '';
    final String lName = json["last_name"] ?? json["lastName"] ?? '';
    String fullName = json["fullNames"] ?? '';
    if (fullName.isEmpty && (fName.isNotEmpty || lName.isNotEmpty)) {
      fullName = '$fName $lName'.trim();
    }

    return UserModel(
      id: json["id"] as int?,
      expireIn: json["expireIn"] != null ? int.tryParse(json["expireIn"].toString()) ?? 0 : null,
      uid: json["uid"]?.toString() ?? '',
      fullNames: fullName,
      roles: List<dynamic>.from(json["Roles"] ?? []),
      role: UserRoleExtension.fromString(json['role'] ?? ''),
      email: json["email"] as String?,
      is_online: json["is_online"] ?? false,
      last_seen: DateTime.tryParse(json["last_seen"] ?? ""),
      password: json["password"] ?? '',
      regionCityAdress: json['regionCityAdress'] ?? '',
      phoneNumber: json["phoneNumber"] ?? json["phone"] ?? '',
      photoUrl: json["photoUrl"] ?? json["avatar_url"],
      provider: json["provider"] ?? '',
      token: json["token"] as String?,
      createdAt: json["createdAt"] as String?,
      deviceToken: json["deviceToken"] ?? json["push_token"] as String?,
      deviceId: json["deviceId"] ?? '',
      refreshToken: json["refreshToken"] ?? '',
      updatedAt: json["updatedAt"] as String?,
      slug: json["slug"],
      passwordHash: json["password_hash"],
      firstNameField: fName,
      lastNameField: lName,
      avatarUrl: json["avatar_url"] ?? json["photoUrl"],
      gpsLatitude: json["gps_latitude"] != null ? double.tryParse(json["gps_latitude"].toString()) : null,
      gpsLongitude: json["gps_longitude"] != null ? double.tryParse(json["gps_longitude"].toString()) : null,
      emailVerified: json["email_verified"] ?? false,
      phoneVerified: json["phone_verified"] ?? false,
      pushToken: json["push_token"] ?? json["deviceToken"],
      lockedUntil: json["locked_until"] != null ? DateTime.tryParse(json["locked_until"].toString()) : null,
      language: json["language"],
      timezone: json["timezone"],
      status: json["status"] ?? 'active',
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, uid: $uid, fullNames: $fullNames, email: $email, phoneNumber: $phoneNumber, photoUrl: $photoUrl, provider: $provider, token: $token, regionCityAdress: $regionCityAdress, createdAt: $createdAt, updatedAt: $updatedAt)';
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
    result.addAll({'slug': slug});
    result.addAll({'password_hash': passwordHash});
    result.addAll({'first_name': firstNameField ?? firstName});
    result.addAll({'last_name': lastNameField ?? lastName});
    result.addAll({'avatar_url': avatarUrl ?? photoUrl});
    result.addAll({'gps_latitude': gpsLatitude});
    result.addAll({'gps_longitude': gpsLongitude});
    result.addAll({'email_verified': emailVerified});
    result.addAll({'phone_verified': phoneVerified});
    result.addAll({'push_token': pushToken ?? deviceToken});
    result.addAll({'locked_until': lockedUntil?.toIso8601String()});
    result.addAll({'language': language});
    result.addAll({'timezone': timezone});
    result.addAll({'status': status});

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

    final String fName = map['first_name'] ?? map['firstName'] ?? '';
    final String lName = map['last_name'] ?? map['lastName'] ?? '';
    String fullName = map['fullNames'] ?? '';
    if (fullName.isEmpty && (fName.isNotEmpty || lName.isNotEmpty)) {
      fullName = '$fName $lName'.trim();
    }

    return UserModel(
      id: parsedId,
      uid: parsedUid,
      fullNames: fullName,
      roles: map['Roles'] ?? map['roles'] ?? [],
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? map['phone'] ?? '',
      photoUrl: map['photoUrl'] ?? map['avatar_url'] ?? '',
      role: UserRoleExtension.fromString(map['role'] ?? ''),
      provider: map['provider'] ?? '',
      token: map['token'] ?? '',
      deviceToken: map["deviceToken"] ?? map["push_token"] ?? '',
      regionCityAdress: map['regionCityAdress'] ?? '',
      password: map["password"] ?? '',
      refreshToken: map["refreshToken"] ?? map["refresh_token"] ?? '',
      agentId: map['agentId'],
      deviceId: map['deviceId'] ?? '',
      createdAt: map['createdAt'] ?? map['created_at'] ?? DateTime.now().toString(),
      updatedAt: map['updatedAt'] ?? map['updated_at'] ?? DateTime.now().toString(),
      slug: map['slug'],
      passwordHash: map['password_hash'],
      firstNameField: fName,
      lastNameField: lName,
      avatarUrl: map['avatar_url'] ?? map['photoUrl'],
      gpsLatitude: map['gps_latitude'] != null ? double.tryParse(map['gps_latitude'].toString()) : null,
      gpsLongitude: map['gps_longitude'] != null ? double.tryParse(map['gps_longitude'].toString()) : null,
      emailVerified: map['email_verified'] ?? false,
      phoneVerified: map['phone_verified'] ?? false,
      pushToken: map['push_token'] ?? map['deviceToken'],
      lockedUntil: map['locked_until'] != null ? DateTime.tryParse(map['locked_until'].toString()) : null,
      language: map['language'],
      timezone: map['timezone'],
      status: map['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => json.encode(toMap());

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel.fromMap(json);

  factory UserModel.fromJsonString(String source) =>
      UserModel.fromMap(json.decode(source));

  factory UserModel.fromLocalMap(Map<String, dynamic> map) {
    return UserModel.fromMap(map);
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
    String? slug,
    String? passwordHash,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    double? gpsLatitude,
    double? gpsLongitude,
    bool? emailVerified,
    bool? phoneVerified,
    String? pushToken,
    DateTime? lockedUntil,
    String? language,
    String? timezone,
    String? status,
  }) {
    String? fName = firstName;
    String? lName = lastName;
    if (fullNames != null && firstName == null && lastName == null) {
      final parts = fullNames.trim().split(' ');
      fName = parts.isNotEmpty ? parts.first : '';
      lName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }
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
      slug: slug ?? this.slug,
      passwordHash: passwordHash ?? this.passwordHash,
      firstNameField: fName ?? this.firstNameField,
      lastNameField: lName ?? this.lastNameField,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gpsLatitude: gpsLatitude ?? this.gpsLatitude,
      gpsLongitude: gpsLongitude ?? this.gpsLongitude,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      pushToken: pushToken ?? this.pushToken,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      status: status ?? this.status,
    );
  }
}
