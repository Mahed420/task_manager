import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';


class SignInController extends GetxController {
  var _signInProgress = false;


  bool get signInProgress => _signInProgress;

  Future<NetworkResponse> signIn(Map<String, dynamic> requestBody) async {
    _signInProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.loginUrl,
        body: requestBody
    );
    _signInProgress = false;
    update(); // Notify GetBuilder again after request completes
    return response;
  }
}
