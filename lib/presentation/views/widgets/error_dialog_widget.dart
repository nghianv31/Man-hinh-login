import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/AppStrings.dart';
import '../../../core/theme/theme.dart';

class ErrorDialogWidget extends StatelessWidget {
  final String message;

  const ErrorDialogWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Text(
        AppStrings.loginError,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: colorScheme.onSurface),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
          ),
          onPressed: () => Get.back(),
          child: const Text(
            AppStrings.close,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
