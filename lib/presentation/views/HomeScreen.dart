import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/values/AppStrings.dart';

import 'package:bt1/presentation/controller/user_controller.dart';

class HomeScreen extends GetView<UserController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text(AppStrings.noUserData));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppStrings.account}: ${user.account}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Fullname: ${user.fullName ?? AppStrings.notUpdated}', style: const TextStyle(fontSize: 18)),
            ],
          ),
        );
      }),
    );
  }
}
