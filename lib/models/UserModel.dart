import 'package:hive/hive.dart';

part 'UserModel.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String taxCode;

  @HiveField(1)
  final String account;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final bool isLoginned;

  UserModel({
    required this.taxCode,
    required this.account,
    required this.password,
    this.isLoginned = false,
  });

  Map<String, dynamic> toJson() => {
    'taxCode': taxCode,
    'account': account,
    'password': password,
    'isLoginned': isLoginned,
  };
}
