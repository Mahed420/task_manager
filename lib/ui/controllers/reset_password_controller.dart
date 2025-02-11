import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class ResetPasswordController extends GetxController {
  bool isChecking = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();



  Future<void> resetPassword(BuildContext context,emailInput,otpInput) async {
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      showSnackBarMessage(context, 'Please enter a new password.');
      return;
    }

    isChecking = true;
    update();

    Map<String, dynamic> bodyData = {
      'email': emailInput,
      'OTP': otpInput,
      'password': confirmPasswordController.text.trim()
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.resetPasswordUrl,
      body: bodyData,
    );

    if (response.isSuccess) {
      if (response.responseData?['status'] == "fail") {
        showSnackBarMessage(context, 'Error: ${response.responseData?['data']}');
      } else {
        showSnackBarMessage(context, 'Password changed successfully');
        Get.offAllNamed(SignInScreen.name);
      }
    } else {
      showSnackBarMessage(context, 'Error: ${response.errorMessage}');
    }

    isChecking = false;
    update();
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}