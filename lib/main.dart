import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquidity_tracker/routes/app_pages.dart';
import 'package:liquidity_tracker/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.main,
      getPages: AppPages.pages,
    );
  }
}
