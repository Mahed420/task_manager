import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';
import '../controllers/reset_password_controller.dart';
import '../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatelessWidget {

  static const String name = '/forgot-password/reset-password';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String email = args['email'] ?? '';
    final String otp = args['otp'] ?? '';
    return GetBuilder<ResetPasswordController>(
      init: ResetPasswordController(),
      builder: (controller) {
        return Scaffold(
          body: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text('Set Password', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Minimum length of password should be more than 8 letters.',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: controller.newPasswordController,
                        decoration: const InputDecoration(hintText: 'New Password'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.confirmPasswordController,
                        decoration: const InputDecoration(hintText: 'Confirm New Password'),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: controller.isChecking
                            ? null
                            : () => controller.resetPassword(context,email,otp),
                        child: controller.isChecking
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
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Have an account? ",
                            style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: 'Sign in',
                                style: const TextStyle(color: AppColors.themeColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.offAllNamed(SignInScreen.name),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
