import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/view_models/task_view_model.dart';
import 'package:task_management/view_models/theme_view_model.dart';
import 'package:task_management/views/add_edit_task_screen.dart';
import 'package:task_management/views/settings_screen.dart';
import 'package:task_management/views/task_details_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TaskModel? selectedTask; // For tablet view

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskViewModelProvider);
    final sortBy = ref.watch(sortPreferenceProvider);
    // Check screen width
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            ),
          )
        ],
      ),
      body: isTablet ? _buildTabletView(tasks) : _buildMobileView(tasks),
      // Responsive layout
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Mobile View: Full-screen List
  Widget _buildMobileView(List<TaskModel> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return TaskTile(
          task: task,
          onTap: () {},
          onDelete: () {
            ref.read(taskViewModelProvider.notifier).removeTask(task.id);
          },
          onToggle: () {
            ref.read(taskViewModelProvider.notifier).toggleTask(task.id);
          },
        );
      },
    );
  }

  // Tablet View: Split View with List & Details
  Widget _buildTabletView(List<TaskModel> tasks) {
    return Row(
      children: [
        // Task List (Left Side)
        Expanded(
          flex: 2,
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return TaskTile(
                task: task,
                onTap: () => setState(() => selectedTask = task),
                // Show in details panel
                onDelete: () {
                  ref.read(taskViewModelProvider.notifier).removeTask(task.id);
                  if (selectedTask?.id == task.id) {
                    // Clear details if deleted
                    selectedTask = null;
                  }
                },
                onToggle: () {
                  ref.read(taskViewModelProvider.notifier).toggleTask(task.id);
                },
                isSelected: selectedTask?.id == task.id,
              );
            },
          ),
        ),

        // Task Details (Right Side)
        Expanded(
          flex: 3,
          child: selectedTask != null
              ? TaskDetailsSection(task: selectedTask!) // Show Task Details
              : Center(child: Text("Select a task to view details")),
        ),
      ],
    );
  }
}

// 📌 Reusable TaskTile Widget
class TaskTile extends ConsumerWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final bool isSelected;

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
    required this.onToggle,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: onTap,
      leading: IconButton(
        icon: Icon(
            task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
        onPressed: onToggle,
      ),
      title: Text(
        task.title,
        style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(
        task.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null),
      ),
      // Highlight selected task on tablet
      tileColor: isSelected ? Colors.grey : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.priority.name.toUpperCase(), // Show priority
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: task.priority == TaskPriority.high
                  ? Colors.red
                  : task.priority == TaskPriority.medium
                      ? Colors.orange
                      : Colors.green,
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTaskScreen(task: task),
                ),
              );
            },
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context, ref)),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              ref.read(taskViewModelProvider.notifier).removeTask(task.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
