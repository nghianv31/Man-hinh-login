import 'package:bt1/firebase_options.dart';
import 'package:bt1/repo/AuthRepo.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/theme.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'models/UserModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(UserModelAdapter());
  
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('currentUser');
  await Hive.openBox('settings');
  
  // Check login session
  final bool isLoggedIn = await AuthRepo().checkLogin();
  final String initialRoute = isLoggedIn ? AppRoutes.home : AppRoutes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isFirstRun;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    isFirstRun = Hive.box('settings').get('isFirstLogin', defaultValue: true);
    if (!isFirstRun) {
      // currentUser = _userRepo.getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: widget.initialRoute,
      getPages: AppPages.routes,
    );
  }
}
