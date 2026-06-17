import 'package:bt1/repo/UserRepo.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/UserModel.dart';
import 'view/HomeScreen.dart';
import 'view/LoginScreen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('settings');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserRepo _userRepo = UserRepo();
  late bool isFirstRun;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    isFirstRun = Hive.box('settings').get('isFirstLogin', defaultValue: true);
    if (!isFirstRun) {
      currentUser = _userRepo.getUser();
    }
    print(isFirstRun);
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF24E1E)),
      ),
      home: (isFirstRun || user == null)
          ? const LoginScreen()
          : HomeScreen(user: user),
    );
  }
}
