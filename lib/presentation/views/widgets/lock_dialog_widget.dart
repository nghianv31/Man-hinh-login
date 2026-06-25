import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/AppStrings.dart';
import '../../controller/login_controller.dart';

class LockDialogWidget extends GetView<LoginController> {
  const LockDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        AppStrings.loginError, 
        textAlign: TextAlign.center,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      content: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.lockLogin,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 10),
          Text(
            'Vui lòng thử lại sau: ${controller.countdownSeconds.value} giây',
            style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.error),
          ),
        ],
      )),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
          ),
          onPressed: () => Get.back(),
          child: const Text(AppStrings.close, style: TextStyle(color: Colors.white)),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
