import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';
import '../widgets/snack_bar_message.dart';

class UpdateProfileController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Rx<XFile?> pickedImage = Rx<XFile?>(null);
  RxBool updateProfileInProgress = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.text = AuthController.userModel?.email ?? '';
    firstNameController.text = AuthController.userModel?.firstName ?? '';
    lastNameController.text = AuthController.userModel?.lastName ?? '';
    mobileController.text = AuthController.userModel?.mobile ?? '';
  }

  Future<void> pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = image;
    }
  }

  void onTapUpdateButton() {
    if (formKey.currentState!.validate()) {
      updateProfile();
    }
  }

  Future<void> updateProfile() async {
    updateProfileInProgress.value = true;

    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "mobile": mobileController.text.trim(),
    };

    if (pickedImage.value != null) {
      List<int> imageBytes = await pickedImage.value!.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }

    if (passwordController.text.isNotEmpty) {
      requestBody['password'] = passwordController.text;
    }

    final response = await NetworkCaller.postRequest(
      url: Urls.updateProfile,
      body: requestBody,
    );

    updateProfileInProgress.value = false;

    if (response.isSuccess) {
      passwordController.clear();
      showSnackBarMessage(Get.context!, 'Profile updated successfully!');
    } else {
      showSnackBarMessage(Get.context!, response.errorMessage);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
