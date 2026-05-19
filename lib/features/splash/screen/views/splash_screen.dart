import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hayzee152_app/core/services/notifications/fcm_service.dart';
import 'package:hayzee152_app/core/services/notifications/fcm_token_sync.dart';
import 'package:hayzee152_app/core/services/storage_service.dart';
import 'package:hayzee152_app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!StorageService.isOnboardingComplete) {
      Get.offAllNamed(AppRoute.getOnboardingScreen());
    } else if (StorageService.hasToken() || StorageService.isGuest) {
      if (StorageService.hasToken()) {
        FcmTokenSync.sync();
      }
      Get.offAllNamed(AppRoute.getHomeScreen());
      await Future.delayed(const Duration(milliseconds: 300));
      await FcmService.handleInitialMessage();
    } else {
      Get.offAllNamed(AppRoute.getWelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/logo/nurseprep_logo_transparent.png', height: 180)),
          ],
        ),
      ),
    ),
    );
  }
}
