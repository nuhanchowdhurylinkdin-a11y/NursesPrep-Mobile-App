import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hayzee152_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'core/services/notifications/notification_initializer.dart';
import 'core/services/storage_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: SystemUiOverlay.values,
  );
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await StorageService.init();
  await NotificationInitializer.init();
  final revenueCatKey = Platform.isAndroid
      ? dotenv.env['REVENUECAT_ANDROID_KEY']!
      : dotenv.env['REVENUECAT_IOS_KEY']!;

  await Purchases.configure(
    PurchasesConfiguration(revenueCatKey),
  );
  await _initialize();
  runApp(const MyApp());
}

Future<void> _initialize() async {
  await Future.delayed(const Duration(milliseconds: 500));
  FlutterNativeSplash.remove();
}