import 'package:hive/hive.dart';

part 'UserModel.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String taxCode;

  @HiveField(1)
  final String account;

  @HiveField(2)
  final String passwordHash;

  @HiveField(3)
  final String? fullName;

  @HiveField(4)
  final String id;

  UserModel({
    required this.id,
    required this.taxCode,
    required this.account,
    required this.passwordHash,
    this.fullName,
  });

  UserModel copyWith({
    String? id,
    String? taxCode,
    String? account,
    String? passwordHash,
    String? fullName,
  }) {
    return UserModel(
      id: id ?? this.id,
      taxCode: taxCode ?? this.taxCode,
      account: account ?? this.account,
      passwordHash: passwordHash ?? this.passwordHash,
      fullName: fullName ?? this.fullName,
    );
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      taxCode: json['taxIdOrId'] as String? ?? '',
      passwordHash: json['passwordHash'] as String? ?? '',
      account: json['username'] as String,
      fullName: json['fullName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'taxCode': taxCode,
    'username': account,
    'passwordHash': passwordHash,
    'fullName': fullName,
  };
}
