import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/view_models/sort_pref_view_model.dart';
import 'package:task_management/view_models/task_view_model.dart';
import 'package:task_management/views/add_edit_task_screen.dart';
import 'package:task_management/views/settings_screen.dart';
import 'package:task_management/views/task_details_section.dart';
import 'package:task_management/widgets/task_tile_widget.dart';

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
    final sortBy = ref.watch(sortPrefViewModelProvider);
    // Check screen width
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          // Sorting Popup
          PopupMenuButton(
            icon: Icon(Icons.sort),
            initialValue: sortBy,
            itemBuilder: (context) => [
              PopupMenuItem(value: "date", child: Text("Date")),
              PopupMenuItem(value: "priority", child: Text("Priority")),
            ],
            onSelected: (value) {
              // Save sort preference
              ref
                  .read(sortPrefViewModelProvider.notifier)
                  .updateSortPreference(value);
              // Sort task according to preference
              ref.read(taskViewModelProvider.notifier).sortTasks();
            },
          ),
          // Settings Button
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            ),
          ),
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
          onTap: () {
            selectedTask = task;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsSection(task: selectedTask!),
                ));
          },
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
