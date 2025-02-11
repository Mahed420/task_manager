import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';


class SignUpController extends GetxController {
  var _isLoading = false;
  bool get isLoading => _isLoading;

  Future<NetworkResponse> registerUser(Map<String, dynamic> requestBody) async {
    _isLoading = true;
    update(); // Notify GetBuilder

    final response = await NetworkCaller.registerRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );

    _isLoading = false;
    update(); // Notify GetBuilder again after request completes

    return response;
  }
}
