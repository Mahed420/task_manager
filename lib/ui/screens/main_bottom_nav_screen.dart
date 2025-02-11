import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/cancelled_task_list_screen.dart';
import 'package:task_manager/ui/screens/complete_task_list_screen.dart';
import 'package:task_manager/ui/screens/new_task_list_screen.dart';
import 'package:task_manager/ui/screens/progress_task_list_screen.dart';
import '../controllers/bottom_nav_controller.dart';

class MainBottomNavScreen extends StatelessWidget {
  const MainBottomNavScreen({super.key});

  static const String name = '/home';

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final BottomNavController controller = Get.put(BottomNavController());

    final List<Widget> screens = [
      NewTaskListScreen(),
      ProgressTaskListScreen(),
      CompleteTaskListScreen(),
      CancelledTaskListScreen(),
    ];

    return GetBuilder<BottomNavController>(
      builder: (controller) {
        return Scaffold(
          body: screens[controller.selectedIndex ?? 0],
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.selectedIndex ?? 0,
            onDestinationSelected: (index) => controller.changeTab(index),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.new_label_outlined), label: 'New'),
              NavigationDestination(
                  icon: Icon(Icons.refresh), label: 'Progress'),
              NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
              NavigationDestination(
                  icon: Icon(Icons.cancel_outlined), label: 'Cancelled'),
            ],
          ),
        );
      },
    );
  }
}
