import 'package:hive/hive.dart';

class SettingBox {
  static final Box box = Hive.box('Settings');

  //status login
  static bool get loginStatus => box.get('loginStatus') ?? false;
  static set loginStatus(bool status) => box.put('loginStatus', status);

  //error login 
  static int get countErrorLogin => box.get('countErrorLogin') ?? 0;
  static set countErrorLogin(int count) => box.put('countErrorLogin', count);

  //lock login until (timestamp in milliseconds)
  static int get lockUntil => box.get('lockUntil') ?? 0;
  static set lockUntil(int timestamp) => box.put('lockUntil', timestamp);

  static const int timeLock = 30; // seconds
  static const int errorCountLock = 2; // failed attempts

  static String get lockedUserId => box.get('lockedUserId') ?? '';
  static set lockedUserId(String id) => box.put('lockedUserId', id);
}