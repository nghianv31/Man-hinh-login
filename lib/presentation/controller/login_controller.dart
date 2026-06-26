import 'dart:async';
import 'package:bt1/core/routes/app_routes.dart';
import 'package:bt1/data/local/setting_box.dart';
import 'package:bt1/repo/AuthRepo.dart';
import 'package:bt1/repo/UserRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/values/AppStrings.dart';
import '../../core/exceptions/auth_exception.dart';
import '../views/widgets/lock_dialog_widget.dart';
import '../views/widgets/error_dialog_widget.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final BaseUserRepo baseUserRepo;
  final BaseAuthRepo baseAuthRepo;
  LoginController(this.baseUserRepo, this.baseAuthRepo);

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final RxBool isShowPass = false.obs;

  //lock state
  final RxBool isLockLogin = false.obs;
  final RxInt countdownSeconds = 0.obs;
  Timer? _lockTimer;

  late AnimationController shakeController;

  final TextEditingController taxCodeController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode taxCodeFocus = FocusNode();
  final FocusNode accountFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    shakeController = AnimationController(vsync: this);
    getBiometric();
  }

  void getBiometric() async {
    final auth = LocalAuthentication();
    try {
      
      print(await auth.canCheckBiometrics);
      print(await auth.isDeviceSupported());
      print(await auth.getAvailableBiometrics());
    } catch (e) {
      debugPrint("Lỗi lấy thông tin sinh trắc học: $e");
    }
  }

  @override
  void onReady() {
    super.onReady();
    getBiometric();
    _checkLockState();
  }

  void _checkLockState() {
    int remaining =
        (SettingBox.lockUntil - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    if (remaining > 0) {
      countdownSeconds.value = remaining;
      isLockLogin.value = true;
      _startTimer();
      showLockDialog();
    } else {
      _unlock();
    }
  }

  void _startTimer() {
    _lockTimer?.cancel();
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
      } else {
        timer.cancel();
        _unlock();
      }
    });
  }

  void _unlock() async {
    SettingBox.countErrorLogin = 0;
    SettingBox.lockUntil = 0;
    isLockLogin.value = false;

    if (SettingBox.lockedUserId.isNotEmpty) {
      try {
        await baseUserRepo.updateTimeLockLogin("0", SettingBox.lockedUserId);
        SettingBox.lockedUserId =
            ""; // Xóa bộ nhớ local sau khi unlock thành công
      } catch (e) {
        debugPrint("Lỗi unlock remote: $e");
      }
    }

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void showLockDialog() {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(const LockDialogWidget(), barrierDismissible: false);
  }

  @override
  void onClose() {
    _lockTimer?.cancel();
    taxCodeController.dispose();
    accountController.dispose();
    passwordController.dispose();
    taxCodeFocus.dispose();
    accountFocus.dispose();
    passwordFocus.dispose();
    shakeController.dispose();
    super.onClose();
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
    if (isLockLogin.value) {
      showLockDialog();
      return;
    }

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
        SettingBox.countErrorLogin = 0; // Reset on success
        Get.offAllNamed(AppRoutes.home);
      } on AuthException catch (e) {
        if (e.type == AuthErrorType.locked) {
          _checkLockState();
        } else {
          String displayMessage = '';
          switch (e.type) {
            case AuthErrorType.accountNotExist:
              displayMessage = AppStrings.accountNotExist;
              break;
            case AuthErrorType.wrongPassword:
              displayMessage = AppStrings.loginFailed;
              break;
            default:
              displayMessage = AppStrings.errorServer;
          }
          message.value = displayMessage;
          Get.dialog(ErrorDialogWidget(message: message.value));
        }
        taxCodeController.clear();
        accountController.clear();
        passwordController.clear();
        update();
      } catch (e) {
        message.value = AppStrings.errorServer;
        Get.dialog(ErrorDialogWidget(message: message.value));
        update();
      } finally {
        isLoading.value = false;
        message.value = '';
      }
    } else {
      shakeController.forward(from: 0.0);
    }

    TextInput.finishAutofillContext();
  }
}
