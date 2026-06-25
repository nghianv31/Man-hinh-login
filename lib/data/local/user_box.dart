import 'package:hive/hive.dart';

import '../../models/UserModel.dart';

class UserBox {

  static final UserModel user1 = UserModel(
    id: '1',
    taxCode: '1111111111',
    account: 'demo',
    passwordHash: '123456',
  );
  final Box<UserModel> _box = Hive.box<UserModel>('users');
  final Box _boxCurrentUser = Hive.box('currentUser');
  Future<void> addUsers(UserModel user) async {
    await _box.put(user.id, user);
  }
  List<UserModel>? getUsers(){
    return _box.values.toList();
  }
  Future<void> addCurrentUser(UserModel user) async {
    await _boxCurrentUser.put('currentUser', user.toJson());
  }
  UserModel? getCurrentUser() {
    return UserModel.fromJson(_boxCurrentUser.get('currentUser'));
  }

 
}