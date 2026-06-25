import 'package:hive/hive.dart';

class SettingBox {
  static final Box box = Hive.box('Settings');

  //status login
  static bool get loginStatus => box.get('loginStatus') ?? false;
  static set loginStatus(bool status) => box.put('loginStatus', status);
}