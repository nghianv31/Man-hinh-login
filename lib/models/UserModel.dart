import 'package:hive/hive.dart';

part 'UserModel.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String msThue;

  @HiveField(1)
  final String taiKhoan;

  @HiveField(2)
  final String matKhau;

  @HiveField(3)
  final bool isLoginned;

  UserModel({
    required this.msThue,
    required this.taiKhoan,
    required this.matKhau,
    this.isLoginned = false,
  });

  Map<String, dynamic> toJson() => {
        'msThue': msThue,
        'taiKhoan': taiKhoan,
        'matKhau': matKhau,
        'isLoginned': isLoginned,
      };
}

