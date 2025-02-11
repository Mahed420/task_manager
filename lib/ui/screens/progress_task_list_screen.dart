import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/task_item_widget.dart';
import 'package:task_manager/ui/widgets/task_status_summary_counter_widget.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';
import '../controllers/progress_task_controller.dart';

class ProgressTaskListScreen extends StatelessWidget {
  final ProgressTaskController controller = Get.put(ProgressTaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: RefreshIndicator(
          onRefresh: controller.updateData,
          child: GetBuilder<ProgressTaskController>(
            initState: (_) => controller.updateData(),
            builder: (ctrl) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ctrl.isLoadingCount
                        ? const CenteredCircularProgressIndicator()
                        : _buildTasksSummaryByStatus(ctrl),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ctrl.isLoadingTasks
                          ? const CenteredCircularProgressIndicator()
                          : _buildTaskListView(ctrl),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskListView(ProgressTaskController ctrl) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: ctrl.newTaskListModel?.taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          taskModel: ctrl.newTaskListModel!.taskList![index],
          updateTaskCallBack: ctrl.updateData,
        );
      },
    );
  }

  Widget _buildTasksSummaryByStatus(ProgressTaskController ctrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ctrl.taskCountByStatusModel?.taskByStatusList?.length ?? 0,
          itemBuilder: (context, index) {
            final model = ctrl.taskCountByStatusModel!.taskByStatusList![index];
            return TaskStatusSummaryCounterWidget(
              title: model.sId ?? '',
              count: model.sum.toString(),
            );
          },
        ),
      ),
    );
  }
}
