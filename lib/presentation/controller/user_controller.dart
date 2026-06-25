import 'package:bt1/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../repo/UserRepo.dart';
import '../../repo/AuthRepo.dart';
import '../../core/routes/app_routes.dart';
import '../../core/values/AppStrings.dart';

class UserController extends GetxController {
  final BaseUserRepo baseUserRepo;
  UserController(this.baseUserRepo);

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      isLoading.value = true;
      final user = await baseUserRepo.getCurrentUser();
      this.user.value = user;
    } catch (e) {
      message.value = e.toString();
      Get.defaultDialog(
        title: AppStrings.error,
        middleText: message.value,
        textConfirm: AppStrings.close,
        confirmTextColor: Colors.white,
        onConfirm: () => Get.back(),
      );
    } finally {
      isLoading.value = false;
      message.value = '';
    }
  }

  void logout() {
    Get.defaultDialog(
      title: AppStrings.logout,
      middleText: AppStrings.confirmLogout,
      textCancel: AppStrings.cancel,
      textConfirm: AppStrings.ok,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final authRepo = AuthRepo();
        await authRepo.logout();
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }
}
