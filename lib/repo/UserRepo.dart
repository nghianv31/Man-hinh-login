import 'package:hive_flutter/hive_flutter.dart';
import 'package:bt1/models/UserModel.dart';

class UserRepo {
  // Singleton instance
  static final UserRepo _instance = UserRepo._internal();
  factory UserRepo() => _instance;
  UserRepo._internal();

  final Box<UserModel> _box = Hive.box<UserModel>('users');

  static final UserModel user1 = UserModel(
    msThue: '1111111111',
    taiKhoan: 'demo',
    matKhau: '123456',
  );

  Future<void> addUser(UserModel user) async {
    await _box.put('currentUser', user);
  }

  UserModel? getUser() {
    return _box.get('currentUser');
  }

  bool compareUser(UserModel user) {
    return user.msThue == user1.msThue &&
        user.taiKhoan == user1.taiKhoan &&
        user.matKhau == user1.matKhau;
  }
}
