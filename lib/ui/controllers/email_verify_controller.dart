import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../screens/forgot_password_verify_otp_screen.dart';

class EmailVerifyController extends GetxController {

  final TextEditingController emailController = TextEditingController();
  RxBool isChecking = false.obs;

  Future<void> verifyEmail(BuildContext context) async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      showSnackBarMessage(context, 'Please enter email address');
      return;
    }

    isChecking.value = true;

    NetworkResponse response = await NetworkCaller.getRequest(
        url: '${Urls.recoverVerifyEmailUrl}/$email');

    if (response.isSuccess) {
      Map<String, dynamic>? responseData = response.responseData;
      if (responseData?['status'] == "fail") {
        showSnackBarMessage(context, 'Error: ${responseData?['data']}');
      } else {
        debugPrint('Mail is: $email');
        Get.toNamed(arguments: {"email": email.trim().toString()},ForgotPasswordVerifyOtpScreen.name);
      }
    } else {
      showSnackBarMessage(context, 'Error: ${response.errorMessage}');
    }

    isChecking.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}