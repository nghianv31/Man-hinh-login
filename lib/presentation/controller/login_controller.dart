import 'package:bt1/core/routes/app_routes.dart';
import 'package:bt1/repo/AuthRepo.dart';
import 'package:bt1/repo/UserRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/values/AppStrings.dart';

class LoginController extends GetxController {
  final BaseUserRepo baseUserRepo;
  final BaseAuthRepo baseAuthRepo;
  LoginController(this.baseUserRepo, this.baseAuthRepo);

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final RxBool isShowPass = false.obs;

  final TextEditingController taxCodeController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode taxCodeFocus = FocusNode();
  final FocusNode accountFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void onClose() {
    taxCodeController.dispose();
    accountController.dispose();
    passwordController.dispose();
    taxCodeFocus.dispose();
    accountFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }

  void toggleShowPass() {
    isShowPass.value = !isShowPass.value;
  }

  bool isTextFieldChange(TextEditingController controller) {
    return controller.text.isNotEmpty;
  }

  void onClickSuffixIcon(TextEditingController controller, bool isPassword) {
    if (isPassword) {
      toggleShowPass();
    } else {
      controller.clear();
      update(); // trigger UI update for suffix icon
    }
  }

  void handleLogin() async {
    final formState = formKey.currentState;
    if (formState != null && formState.validate()) {
      isLoading.value = true;
      formState.save();
      try {
        await baseAuthRepo.login(
          taxCodeController.text,
          accountController.text,
          passwordController.text,
        );
        Get.offAllNamed(AppRoutes.home);
      } catch (e) {
        message.value = e.toString();
        Get.defaultDialog(
          title: AppStrings.loginError,
          middleText: message.value,
          textConfirm: AppStrings.close,
          confirmTextColor: Colors.white,
          onConfirm: () => Get.back(),
        );
        taxCodeController.clear();
        accountController.clear();
        passwordController.clear();
        update();
      }finally{
        isLoading.value = false;
        message.value = '';
      }
    }
  }
}
