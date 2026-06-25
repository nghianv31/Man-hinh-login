import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/AppStrings.dart';
import '../../controller/login_controller.dart';

class LockDialogWidget extends GetView<LoginController> {
  const LockDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(AppStrings.loginError, textAlign: TextAlign.center),
      content: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            AppStrings.lockLogin,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Vui lòng thử lại sau: ${controller.countdownSeconds.value} giây',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      )),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF24E1E),
          ),
          onPressed: () => Get.back(),
          child: const Text(AppStrings.close, style: TextStyle(color: Colors.white)),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
