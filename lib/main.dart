// main.dart
import 'dart:developer';
import 'dart:io';

import 'package:clone/firebase_options.dart';
import 'package:clone/smart_giving/admin/provider/view_fund_service.dart';
import 'package:clone/smart_giving/donor/Provider/donor_provider.dart';
import 'package:clone/smart_giving/notification.dart';
import 'package:clone/smart_giving/providers/auth_provider.dart';
import 'package:clone/smart_giving/providers/bussiness_provider.dart';
import 'package:clone/smart_giving/screens/splash_screen.dart';
import 'package:clone/smart_giving/services/sesion_handle.dart';
import 'package:clone/smart_giving/utlis/navigator/router.dart';
import 'package:clone/smart_giving/utlis/scaffold/scaffolds.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _initializeFCM();

  runApp(MyApp());
}

final FCMService _fcmService = FCMService();
String? deviceToken;
String platformType = Platform.isAndroid ? 'Android' : 'iOS';
bool permissionsGranted = false;
Future<void> _initializeFCM() async {
  // Request FCM permissions
  await _fcmService.requestPermissions();

  // Get the device token
  await _fcmService.getToken();
  deviceToken = _fcmService.token;

  log('Platform: $platformType');
  log('Permissions Granted: $permissionsGranted');
  log('Device Token: $deviceToken');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SesionHandle()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BusinessProvider()),
        ChangeNotifierProvider(create: (context) => ViewFundService()),
        ChangeNotifierProvider(create: (context) => DonorProvider()),
      ],
      builder: (BuildContext context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: Messenger.rootScaffoldMessengerKey,
          navigatorKey: MyRouter.navigatorKey,
          title: 'Smart Giving',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: SplashScreen(),
        );
      },
    );
  }
}
