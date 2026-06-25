
import 'package:bt1/data/remote/firebase_firestore.dart';
import 'package:bt1/models/UserModel.dart';

import '../data/local/user_box.dart';
import '../../core/values/AppStrings.dart';

abstract class BaseUserRepo {
  Future<UserModel> getCurrentUser();
  Future<void> updateTimeLockLogin(String lockUntil, String userId);
}

class UserRepo implements BaseUserRepo {
  final _userBox = UserBox();
  final _firebaseRemote = FirebaseRemote();

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final user = _userBox.getCurrentUser();
      if (user == null) {
        throw Exception(AppStrings.accountNotExist);
      }
      return user;
    } catch (e) {
      throw Exception(e.toString());  
    }
  }

  Future<List<UserModel>?> getListUserFromRemote() async {
    try {
      // get from remote
      final listData = await _firebaseRemote.getCollectionWithCondition(
        collection: 'accounts',
        field: 'enabled',
        value: true,
      );
      final List<UserModel> listUser = listData
          .map((e) => UserModel.fromJson(e))
          .toList();
      // save in local
      for (var element in listUser) {
        await _userBox.addUsers(element);
      }
      return listUser;
    } catch (e) {
      throw Exception(AppStrings.errorServer);
    }
  }

  Future<List<UserModel>?> getListUserFromLocal() async {
    try {
      return _userBox.getUsers();
    } catch (e) {
      throw Exception(AppStrings.errorServer);
    }
  }
  
  @override
  Future<void> updateTimeLockLogin(String lockUntil,String userId)async {
    try {
      await _firebaseRemote.updateDocument(
        collection: 'accounts',
        docId: userId,
        data: {'lockUntil': lockUntil},
      );
    } catch (e) {
      throw Exception(AppStrings.errorServer);
    }
  }
}
