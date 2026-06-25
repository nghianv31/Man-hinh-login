import 'package:bt1/presentation/binding/home_binding.dart';
import 'package:bt1/presentation/views/HomeScreen.dart';
import 'package:get/get.dart';
import '../../presentation/views/LoginScreen.dart';
import 'app_routes.dart';
import '../../presentation/binding/login_binding.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
