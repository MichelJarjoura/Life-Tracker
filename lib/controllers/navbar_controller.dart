import 'package:get/get.dart';

class NavBarController extends GetxController {
  final selectedIndex = 0.obs;

  void changeIndex(int index) => selectedIndex.value = index;

  String get currentTitle {
    switch (selectedIndex.value) {
      case 0:
        return 'Expenses';
      case 1:
        return 'Workout';
      case 2:
        return 'Study';
      default:
        return 'Tracker';
    }
  }
}
