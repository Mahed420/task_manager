class Urls {
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static const String registrationUrl = '$_baseUrl/registration';
  static const String loginUrl = '$_baseUrl/login';
  static const String  createTaskUrl = '$_baseUrl/createTask';
  static const String taskCountByStatusUrl = '$_baseUrl/taskStatusCount';
  static const String taskUpdateStatusUrl = '$_baseUrl/updateTaskStatus';
  static const String taskDeleteStatusUrl = '$_baseUrl/deleteTask';
  static const String recoverVerifyEmailUrl = '$_baseUrl/RecoverVerifyEmail';
  static const String recoverVerifyOTPUrl = '$_baseUrl/RecoverVerifyOTP';
  static const String resetPasswordUrl = '$_baseUrl/RecoverResetPass';

  static String taskListByStatusUrl(String status) =>
      '$_baseUrl/listTaskByStatus/$status';

  static const String updateProfile = '$_baseUrl/profileUpdate';
}


