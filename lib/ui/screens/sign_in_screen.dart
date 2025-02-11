import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/sign_up_controller.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../controllers/sign_in_controller.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  final TextEditingController _emailTEController = TextEditingController();

  final TextEditingController _passwordTEController = TextEditingController();

  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return GetBuilder<SignInController>(
      init: SignInController(),
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
                      Text('Get Started With', style: textTheme.titleLarge),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: widget._emailTEController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: widget._passwordTEController,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Password'),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your valid password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Visibility(
                        visible: controller.signInProgress == false,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: () => {_onTapSignInButton(context,controller)},
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Center(
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context,
                                    ForgotPasswordVerifyEmailScreen.name);
                              },
                              child: const Text('Forgot Password?'),
                            ),
                            _buildSignUpSection(context),
                          ],
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

  void _onTapSignInButton(BuildContext context,SignInController controller) {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> requestBody = {
        "email": widget._emailTEController.text.trim(),
        "password": widget._passwordTEController.text,
      };
      controller.signIn(requestBody).then((response) async {
        if (response.isSuccess) {
          String token = response.responseData!['token'];
          UserModel userModel =
              UserModel.fromJson(response.responseData!['data']);
          await AuthController.saveUserData(token, userModel);
          Get.offNamed(MainBottomNavScreen.name);
        } else {
          if (response.statusCode == 401) {
            showSnackBarMessage(
                context, 'Email/Password is invalid! Try again.');
          } else {
            showSnackBarMessage(context, response.errorMessage);
          }
        }
      });
    }
  }

  Widget _buildSignUpSection(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style:
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: 'Sign up',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(SignUpScreen.name);
              },
          )
        ],
      ),
    );
  }
}
