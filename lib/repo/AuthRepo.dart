import 'dart:convert';
import 'dart:developer';
import 'package:bt1/data/local/secure_storage.dart';
import 'package:bt1/data/local/setting_box.dart';
import 'package:bt1/models/UserModel.dart';
import 'package:bt1/models/session_login.dart';
import 'package:bt1/utils/hash_password.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../core/exceptions/auth_exception.dart';

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
      // Bước 1: Kiểm tra trạng thái khóa nội bộ (Thiết bị) đầu tiên để chặn sớm
      if (SettingBox.lockUntil != 0) {
         int remaining = (SettingBox.lockUntil - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
         if (remaining > 0) {
           throw AuthException(AuthErrorType.locked);
         } else {
           SettingBox.countErrorLogin = 0;
           SettingBox.lockUntil = 0;
           if (SettingBox.lockedUserId.isNotEmpty) {
             try {
               await _userRepo.updateTimeLockLogin("0", SettingBox.lockedUserId);
               SettingBox.lockedUserId = "";
             } catch (e) {
               log("Lỗi unlock remote trong AuthRepo: $e");
             }
           }
         }
      }

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
        // Bước 1: Tìm User bằng taxCode
        UserModel? user;
        try {
          user = listUser.firstWhere((u) => u.taxCode == taxCode);
        } catch (_) {}

        if (user == null) {
          await _handleLoginError(null, AuthErrorType.accountNotExist);
          return;
        }

        // Bước 2: Kiểm tra account và mật khẩu
        bool isAccountCorrect = user.account == account;
        bool isPasswordCorrect = HashPassword.checkHash(password, user.passwordHash);

        if (isAccountCorrect && isPasswordCorrect) {
          SettingBox.countErrorLogin = 0;
          SettingBox.lockUntil = 0;
          await _userBox.addCurrentUser(user);
          
          final session = SessionLogin(userId: user.id, logginAt: DateTime.now().toIso8601String());
          await _initSecureStorage.write(
            '',
            key: 'session',
            value: jsonEncode(session.toMap()),
          );
        } else {
          AuthErrorType errType = !isAccountCorrect 
              ? AuthErrorType.accountNotExist 
              : AuthErrorType.wrongPassword;
          await _handleLoginError(user, errType);
        }
      } else {
        await _handleLoginError(null, AuthErrorType.accountNotExist);
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(AuthErrorType.serverError, message: e.toString());
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

  Future<void> _handleLoginError(UserModel? user, AuthErrorType errorType) async {
    SettingBox.countErrorLogin++;
    if (SettingBox.countErrorLogin >= SettingBox.errorCountLock) {
      SettingBox.lockUntil = DateTime.now().millisecondsSinceEpoch + (SettingBox.timeLock * 1000);
      
      // Chỉ update remote nếu tài khoản có tồn tại (có userId)
      if (user != null) {
        SettingBox.lockedUserId = user.id; // Lưu lại để tí nữa unlock
        try {
          await _userRepo.updateTimeLockLogin(SettingBox.lockUntil.toString(), user.id);
        } catch (e) {
          log("Lỗi update remote lock: $e");
        }
      }
      throw AuthException(AuthErrorType.locked);
    } else {
      throw AuthException(errorType);
    }
  }
}
