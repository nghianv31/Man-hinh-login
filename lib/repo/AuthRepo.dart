import 'dart:convert';
import 'package:bt1/data/local/secure_storage.dart';
import 'package:bt1/models/UserModel.dart';
import 'package:bt1/models/session_login.dart';
import 'package:bt1/utils/hash_password.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../core/values/AppStrings.dart';

import '../data/local/user_box.dart';
import 'UserRepo.dart';

abstract class BaseAuthRepo {
  Future<bool> checkLogin();
  Future<void> login(String taxCode, String account, String password);
  Future<void> logout();
}

class AuthRepo implements BaseAuthRepo {
  final _userBox = UserBox();
  final _userRepo = UserRepo();
  final _initSecureStorage = InitSecureStorage();

  @override
  Future<void> login(String taxCode, String account, String password) async {
    try {
      //check connect internet
      final bool isConnected = await InternetConnection().hasInternetAccess;
      //
      List<UserModel>? listUser;
      if (isConnected) {
        listUser = await _userRepo.getListUserFromRemote();
      } else {
        listUser = await _userRepo.getListUserFromLocal();
      }
      if (listUser != null && listUser.isNotEmpty) {
        
        final UserModel user = listUser.firstWhere(
          (u) {
            return u.taxCode == taxCode &&
                u.account == account &&
                HashPassword.checkHash(password, u.passwordHash) == true;
          },
          orElse: () {
            throw AppStrings.accountNotExist;
          },
        );
        await _userBox.addCurrentUser(user);
        // save session
        final session = SessionLogin(userId: user.id, logginAt: DateTime.now().toIso8601String());
        await _initSecureStorage.write(
          '',
          key: 'session',
          value: jsonEncode(session.toMap()),
        );
      }
    } catch (e) {
      throw e.toString().replaceAll('Exception: ', '');
    }
  }

  @override
  Future<void> logout() async {
    await _initSecureStorage.delete(key: 'session');
  }

  @override
  Future<bool> checkLogin() async{
    try {
      return await _initSecureStorage.read(key: 'session') != null;
    } catch (e) {
      return false;
    }
  }
}
