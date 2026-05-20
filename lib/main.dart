import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:liquidity_tracker/core/theme/app_theme.dart';
import 'package:liquidity_tracker/features/auth/controllers/auth_controller.dart';
import 'package:liquidity_tracker/core/routes/app_pages.dart';
import 'package:liquidity_tracker/core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jzjeruxlmuzvuczftntk.supabase.co', // your project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6amVydXhsbXV6dnVjemZ0bnRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3NDYwODIsImV4cCI6MjA5NDMyMjA4Mn0.99dpJz1juow5a6X9v53JKNl_INmhr9u6_442Rkh27SY', // your anon public key
  );

  // ✅ AuthController registered permanently BEFORE any route loads,
  //    so Login/Register bindings can safely call Get.find<AuthController>().
  Get.put(AuthController(), permanent: true);

  // Lock to portrait — remove if you want landscape support.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const TrackerApp());
}

class TrackerApp extends StatelessWidget {
  const TrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Life Tracker',
      theme: AppTheme.dark,
      initialRoute: AppRoutes.main,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 220),
    );
  }
}
