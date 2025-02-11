import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0;

  void changeTab(int index) {
    selectedIndex = index;
    update(); // Notify UI to update
  }
}
