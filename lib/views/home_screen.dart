import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/view_models/task_view_model.dart';
import 'package:task_management/views/add_edit_task_screen.dart';
import 'package:task_management/views/settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return ListTile(
            leading: IconButton(
              visualDensity: VisualDensity(horizontal: -4),
              icon: Icon(task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onPressed: () =>
                  ref.read(taskViewModelProvider.notifier).toggleTask(task.id),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null),
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Task screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
