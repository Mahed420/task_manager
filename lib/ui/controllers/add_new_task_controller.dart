import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class AddTaskController extends GetxController {
  RxBool addNewTaskInProgress = false.obs;

  final TextEditingController titleTEController = TextEditingController();
  final TextEditingController descriptionTEController = TextEditingController();

  Future<void> createNewTask() async {
    addNewTaskInProgress.value = true;
    Map<String, dynamic> requestBody = {
      "title": titleTEController.text.trim(),
      "description": descriptionTEController.text.trim(),
      "status": "New"
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.createTaskUrl, body: requestBody);
    addNewTaskInProgress.value = false;
    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMessage(Get.context!, 'New task added!');
    } else {
      showSnackBarMessage(Get.context!, response.errorMessage);
    }
  }

  void _clearTextFields() {
    titleTEController.clear();
    descriptionTEController.clear();
  }

  @override
  void onClose() {
    titleTEController.dispose();
    descriptionTEController.dispose();
    super.onClose();
  }
}
