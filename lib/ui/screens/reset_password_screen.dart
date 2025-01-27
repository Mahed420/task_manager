import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';
import '../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key});

  static const String name = '/forgot-password/reset-password';

  String? email;
  String? otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();




  Future<void> getEmail() async {
    await Future.delayed(const Duration(seconds: 2));
    String? l = await AuthController.getField('email');
    String? p = await AuthController.getField('otp');
    widget.email = l;
    widget.otp = p;
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }
  bool _isChecking = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

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
                  Text('Set Password', style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Minimum length of password should be more than 8 letters.',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _newPasswordTEController,
                    decoration: const InputDecoration(hintText: 'New Password'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration:
                        const InputDecoration(hintText: 'Confirm New Password'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isChecking
                        ? null
                        : () async {
                      if (_confirmPasswordTEController.text.isEmpty&&_newPasswordTEController.text.isEmpty) {
                        showSnackBarMessage(
                            context, 'Please enter New password');
                        return;
                      }
                      setState(() {
                        _isChecking = true;
                      });
                      Map<String,dynamic> bodyData = {
                        'email': widget.email,
                        'OTP': widget.otp,
                        'password' : _confirmPasswordTEController.text.trim()
                      };
                      NetworkResponse response = await NetworkCaller.postRequest(url: Urls.resetPasswordUrl,body: bodyData);

                      if (response.isSuccess) {
                        Map<String, dynamic>? responseData = response.responseData;

                        if (responseData?['status'] == "fail") {
                          showSnackBarMessage(context, 'Error: ${responseData?['data']}');
                        } else {
                          showSnackBarMessage(context, 'Password changed successfully');
                          Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (value) => false);
                        }
                      } else {
                        showSnackBarMessage(
                            context, 'Error: ${response.errorMessage}');
                      }
                      setState(() {
                        _isChecking = false;
                      });
                    },
                    child: _isChecking
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
                    child: _buildSignInSection(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (value) => false);
              },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
