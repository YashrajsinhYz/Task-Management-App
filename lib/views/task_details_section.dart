import 'package:flutter/material.dart';
import 'package:task_management/models/task_model.dart';

class TaskDetailsSection extends StatelessWidget {
  final TaskModel? task;

  const TaskDetailsSection({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    // Check screen width
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: isTablet ? null : AppBar(title: Text("Task Details")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title :"),
            Text(task!.title, style: TextStyle(fontSize: 25)),
            Divider(),
            SizedBox(height: 20),
            Text("Description :"),
            Text(task!.description, style: TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
