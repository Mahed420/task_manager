import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../controllers/sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();

  final TextEditingController _firstNameTEController = TextEditingController();

  final TextEditingController _lastNameTEController = TextEditingController();

  final TextEditingController _mobileTEController = TextEditingController();

  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
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
                      Text('Join With Us', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 24),
                      _buildTextField(_emailTEController, 'Email', TextInputType.emailAddress),
                      const SizedBox(height: 8),
                      _buildTextField(_firstNameTEController, 'First Name'),
                      const SizedBox(height: 8),
                      _buildTextField(_lastNameTEController, 'Last Name'),
                      const SizedBox(height: 8),
                      _buildTextField(_mobileTEController, 'Mobile', TextInputType.phone),
                      const SizedBox(height: 8),
                      _buildPasswordField(),
                      const SizedBox(height: 24),
                      controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                        onPressed: () => _onTapSignUpButton(controller, context),
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                      const SizedBox(height: 48),
                      Center(child: _buildSignInSection()),
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

  Widget _buildTextField(TextEditingController controller, String hint,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(hintText: hint),
      validator: (value) => value!.trim().isEmpty ? 'Enter your $hint' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordTEController,
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Password'),
      validator: (value) {
        if (value!.trim().isEmpty) return 'Enter your password';
        if (value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
    );
  }

  void _onTapSignUpButton(SignUpController controller, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final requestBody = {
        "email": _emailTEController.text.trim(),
        "firstName": _firstNameTEController.text.trim(),
        "lastName": _lastNameTEController.text.trim(),
        "mobile": _mobileTEController.text.trim(),
        "password": _passwordTEController.text,
        "photo": ""
      };

      controller.registerUser(requestBody).then((response) {
        if (response.isSuccess) {
          _clearTextFields();
          showSnackBarMessage(context, 'Registration successful!');
          Get.toNamed(SignInScreen.name);
        } else {
          showSnackBarMessage(context, response.errorMessage);
        }
      });
    }
  }

  void _clearTextFields() {
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _emailTEController.clear();
    _passwordTEController.clear();
    _mobileTEController.clear();
  }

  void _disposeTextFields() {
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _mobileTEController.dispose();
  }

  @override
  void dispose() {
    _disposeTextFields();
    super.dispose();
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: 'Sign in',
            style: const TextStyle(color: AppColors.themeColor),
            recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
          ),
        ],
      ),
    );
  }
}
