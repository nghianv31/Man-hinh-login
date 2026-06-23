import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../repo/UserRepo.dart';
import '../models/UserModel.dart';
import '../core/values/AppStrings.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  void _navigateToLogin(BuildContext context) async {
    final userRepo = UserRepo();
    final updatedUser = UserModel(
      taxCode: user.taxCode,
      account: user.account,
      password: user.password,
      isLoginned: false,
    );
    await userRepo.addUser(updatedUser);
    await Hive.box('settings').put('isFirstLogin', true);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.home)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navigateToLogin(context),
          child: Text(AppStrings.logout),
        ),
      ),
    );
  }
}
