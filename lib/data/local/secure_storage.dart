// Default secure storage - Uses RSA OAEP + AES-GCM (recommended)
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InitSecureStorage {
  final FlutterSecureStorage _storage;
  final String? accountName;

  InitSecureStorage({this.accountName})
      : _storage = FlutterSecureStorage(
          aOptions: const AndroidOptions(
            biometricPromptTitle: 'Flutter Secure Storage Example',
            biometricPromptSubtitle: 'Please unlock to access data.',
          ),
          iOptions: IOSOptions(
            accountName: accountName,
            synchronizable: true,
            // accessControlFlags: [ // Enable for one or more access control features
            //   AccessControlFlag.biometryCurrentSet,
            //   AccessControlFlag.devicePasscode,
            //   AccessControlFlag.and,
            // ],
          ),
          mOptions: MacOsOptions(
            accountName: accountName,
            synchronizable: true,
            // accessControlFlags: [ // Enable for one or more access control features
            //   AccessControlFlag.biometryCurrentSet,
            //   AccessControlFlag.devicePasscode,
            //   AccessControlFlag.and,
          ),
        );

  Future<void> write(String s, {required String key, required dynamic value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
