import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/ui/controllers/update_profile_controller.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileController>(
      init: UpdateProfileController(),
      builder: (controller) {
        final textTheme = Theme.of(context).textTheme;

        return Scaffold(
          appBar: const TMAppBar(fromUpdateProfile: true),
          body: ScreenBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text('Update Profile', style: textTheme.titleLarge),
                      const SizedBox(height: 24),
                      _buildPhotoPicker(controller),
                      const SizedBox(height: 8),
                      _buildTextField(controller.emailController, 'Email', enabled: false),
                      const SizedBox(height: 8),
                      _buildTextField(controller.firstNameController, 'First name',
                          validator: (value) => value!.isEmpty ? 'Enter your first name' : null),
                      const SizedBox(height: 8),
                      _buildTextField(controller.lastNameController, 'Last name',
                          validator: (value) => value!.isEmpty ? 'Enter your last name' : null),
                      const SizedBox(height: 8),
                      _buildTextField(controller.mobileController, 'Mobile',
                          validator: (value) => value!.isEmpty ? 'Enter your phone no' : null),
                      const SizedBox(height: 8),
                      _buildTextField(controller.passwordController, 'Password', obscureText: true),
                      const SizedBox(height: 24),
                      controller.updateProfileInProgress.value
                          ? const CenteredCircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: controller.updateProfile,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
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

  Widget _buildPhotoPicker(UpdateProfileController controller) {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              controller.pickedImage == null ? 'No item selected' : controller.pickedImage!.value.toString(),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool enabled = true, bool obscureText = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      decoration: InputDecoration(hintText: hintText),
      validator: validator,
    );
  }
}
