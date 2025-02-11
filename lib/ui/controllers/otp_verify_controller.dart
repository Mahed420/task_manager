import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class OtpVerifyController extends GetxController {

  late final TextEditingController otpController;

  var isChecking = false.obs;
  var otp = ''.obs;

  @override
  void onInit() {
    otpController = TextEditingController();
    super.onInit();
  }



  Future<void> verifyOtp(String emailInput) async {
    if (otpController.text.trim().toString().isEmpty) {
      showSnackBarMessage(Get.context!, 'Please enter the OTP');
      return;
    }
    if (emailInput.isEmpty) {
      showSnackBarMessage(Get.context!, 'Invalid email address');
      return;
    }

    isChecking.value = true;
    update();
    debugPrint('${Urls.recoverVerifyOTPUrl}/$emailInput/${otpController.text.trim().toString()}');
    final response = await NetworkCaller.getRequest(
      url:
          '${Urls.recoverVerifyOTPUrl}/$emailInput/${otpController.text.trim().toString()}',
    );

    if (response.isSuccess) {
      final responseData = response.responseData;
      if (responseData?['status'] == "fail") {
        showSnackBarMessage(Get.context!, 'Error: ${responseData?['data']}');
      } else {
        otp.value = otpController.text.trim().toString();
        Get.toNamed(arguments: {"email": emailInput.trim().toString(), "otp": otp.trim().toString()},ResetPasswordScreen.name);
      }
    } else {
      showSnackBarMessage(Get.context!, 'Error: ${response.errorMessage}');
    }

    isChecking.value = false;
    update();
  }

  @override
  void onClose() {
    if (otpController.hasListeners) {
      otpController.dispose();
    }
    super.onClose();
  }

}
