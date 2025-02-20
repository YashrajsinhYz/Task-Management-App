import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/view_models/task_view_model.dart';
import 'package:task_management/views/add_edit_task_screen.dart';

// Reusable TaskTile Widget
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
