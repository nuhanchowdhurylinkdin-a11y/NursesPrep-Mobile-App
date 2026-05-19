import 'package:hayzee152_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/bindings/controller_binder.dart';
import 'core/services/storage_service.dart';
import 'core/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Edge-to-edge transparent overlays — actual icon brightness
    // is handled per-theme via AppBarTheme.systemOverlayStyle.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(390, 884),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        // ControllerBinder registers ThemeController, so it's
        // available after initialBinding runs. We use GetBuilder
        // to react to themeMode changes.
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoute.getSplashScreen(),
          getPages: AppRoute.routes,
          initialBinding: ControllerBinder(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _initialThemeMode(),
        );
      },
    );
  }

  /// Read the saved preference synchronously from StorageService
  /// (already initialised in main before runApp).
  ThemeMode _initialThemeMode() {
    final saved = StorageService.themeMode;
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
