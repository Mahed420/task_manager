import 'package:get/get.dart';
import 'package:task_manager/data/models/task_count_by_status_model.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class ProgressTaskController extends GetxController {
  bool isLoadingCount = false;
  bool isLoadingTasks = false;
  TaskCountByStatusModel? taskCountByStatusModel;
  TaskListByStatusModel? newTaskListModel;

  @override
  void onInit() {
    super.onInit();
    updateData();
  }

  Future<void> updateData() async {
    await Future.wait([
      getTaskCountByStatus(),
      getNewTaskList(),
    ]);
  }

  Future<void> getTaskCountByStatus() async {
    isLoadingCount = true;
    update();
    final response = await NetworkCaller.getRequest(url: Urls.taskCountByStatusUrl);
    if (response.isSuccess) {
      taskCountByStatusModel = TaskCountByStatusModel.fromJson(response.responseData!);
    }
    isLoadingCount = false;
    update();
  }

  Future<void> getNewTaskList() async {
    isLoadingTasks = true;
    update();
    final response = await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl('Progress'));
    if (response.isSuccess) {
      newTaskListModel = TaskListByStatusModel.fromJson(response.responseData!);
    }
    isLoadingTasks = false;
    update();
  }
}
