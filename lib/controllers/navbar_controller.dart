import 'package:get/get.dart';

class NavBarController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  String get currentTitle {
    switch (selectedIndex.value) {
      case 0:
        return "Expenses tracker";
      case 1:
        return "Workout tracker";
      case 2:
        return "Study tracker";
      default:
        return "Tracker";
    }
  }
}
