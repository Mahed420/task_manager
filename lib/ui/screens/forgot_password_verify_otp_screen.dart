import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/controllers/otp_verify_controller.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class ForgotPasswordVerifyOtpScreen extends StatelessWidget {
  ForgotPasswordVerifyOtpScreen({super.key});

  static const String name = '/forgot-password/verify-otp';

  final OtpVerifyController authController = Get.put(OtpVerifyController());

  @override
  Widget build(BuildContext context) {


    final Map<String, dynamic> args = Get.arguments ?? {};  // Handle null safely
    final String email = args['email'] ?? '';               // Default to an empty string


    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: GetBuilder<OtpVerifyController>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Text('PIN Verification',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      'A 6-digit OTP has been sent to your email address',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 24),
                    _buildPinCodeTextField(controller),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: controller.isChecking.value
                          ? null
                          : () {
                              controller.verifyOtp(email);
                            },
                      child: controller.isChecking.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Icon(Icons.arrow_circle_right_outlined),
                    ),
                    const SizedBox(height: 48),
                    Center(child: _buildSignInSection()),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinCodeTextField(OtpVerifyController controller) {
    return PinCodeTextField(
      length: 6,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      controller: controller.otpController,
      appContext: Get.context!,
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: "Have an account? ",
        style:
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: 'Sign in',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.offAllNamed(SignInScreen.name);
              },
          )
        ],
      ),
    );
  }
}
