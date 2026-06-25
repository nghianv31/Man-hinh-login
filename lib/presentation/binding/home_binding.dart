import 'package:bt1/repo/UserRepo.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController(UserRepo()));
  }
}