import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquidity_tracker/controllers/auth_controller.dart';
import 'package:liquidity_tracker/controllers/navbar_controller.dart';
import 'package:liquidity_tracker/routes/app_routes.dart';
import 'package:liquidity_tracker/views/expenses_screen.dart';
import 'package:liquidity_tracker/views/study_screen.dart';
import 'package:liquidity_tracker/views/workout/workout_screen.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final navBarController = Get.find<NavBarController>();

    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        toolbarHeight: 85,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.person_2_rounded, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Obx(
            () => authController.isLoggedin.value
                ? Container()
                : TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.login),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text("Login"),
                  ),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 10),
        title: Obx(() {
          return Text(
            navBarController.currentTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
        centerTitle: true,
      ),
      body: Obx(
        () => IndexedStack(
          index: navBarController.selectedIndex.value,
          children: [
            const ExpensesScreen(),
            WorkoutScreen(),
            const StudyScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navBarController.selectedIndex.value,
          onTap: (value) => navBarController.changeIndex(value),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: "Expenses",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: "Workout",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: "Study",
            ),
          ],
        ),
      ),
    );
  }
}
