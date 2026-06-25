import 'package:get/get.dart';
import 'package:bt1/repo/UserRepo.dart';
import 'package:bt1/presentation/controller/login_controller.dart';
import 'package:bt1/repo/AuthRepo.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(UserRepo(), AuthRepo()));
  }
}
