import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class TaskItemWidget extends StatefulWidget {
  TaskItemWidget({
    super.key,
    required this.taskModel,
    this.updateTaskCallBack,
  });

  final TaskModel taskModel;
  final VoidCallback? updateTaskCallBack;

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        title: Text(widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description ?? ''),
            Text('Date: ${widget.taskModel.createdDate ?? ''}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _getStatusColor(widget.taskModel.status ?? 'New'),
                  ),
                  child: Text(
                    widget.taskModel.status ?? 'New',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        deleteCustomDialog(context);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        customEditTaskDialog(context);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void deleteCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _isUpdating = false;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: IntrinsicHeight(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Are you sure want to delete this?",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 80,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("NO"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 80,
                              child: ElevatedButton(
                                onPressed: _isUpdating
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isUpdating = true;
                                        });
                                        final NetworkResponse response =
                                            await NetworkCaller.getRequest(
                                          url:
                                              '${Urls.taskDeleteStatusUrl}/${widget.taskModel.sId}',
                                        );
                                        if (response.isSuccess) {
                                          showSnackBarMessage(context,
                                              "Task deleted successfully");
                                          widget.updateTaskCallBack?.call();
                                        } else {
                                          showSnackBarMessage(
                                              context, response.errorMessage);
                                        }
                                        setState(() {
                                          _isUpdating = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                child: _isUpdating
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text("YES"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> customEditTaskDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          bool _isUpdating = false;
          // Selected value
          String? _selectedItem;
          final List<String> _items = [
            "New",
            "Progress",
            "Cancelled",
            "Completed"
          ];
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: IntrinsicHeight(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StatefulBuilder(
                      builder: (BuildContext context, SetState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          "Select Task Status",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        DropdownButton<String>(
                          hint: const Text("Status"),
                          value: _selectedItem,
                          isExpanded: true,
                          items: _items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            SetState(() {
                              _selectedItem = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _selectedItem == null
                              ? 'No item selected'
                              : 'Selected: $_selectedItem',
                          style: const TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (_selectedItem != null) {
                                SetState(() {
                                  _isUpdating = true;
                                });
                                final NetworkResponse response =
                                    await NetworkCaller.getRequest(
                                        url:
                                            '${Urls.taskUpdateStatusUrl}/${widget.taskModel.sId}/${_selectedItem}');
                                if (response.isSuccess) {
                                  showSnackBarMessage(context,
                                      "Task status updated successfully");
                                  widget.updateTaskCallBack?.call();
                                } else {
                                  showSnackBarMessage(
                                      context, response.errorMessage);
                                }
                                SetState(() {
                                  _isUpdating = false;
                                });
                                Navigator.pop(context);
                              } else {
                                showSnackBarMessage(
                                    context, "Please select a status");
                              }
                            },
                            child: _isUpdating
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Update")),
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        });
  }

  Color _getStatusColor(String status) {
    if (status == 'New') {
      return Colors.blue;
    } else if (status == 'Progress') {
      return Colors.yellow;
    } else if (status == 'Cancelled') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
