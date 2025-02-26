import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/view_models/sort_pref_view_model.dart';
import 'package:task_management/view_models/task_view_model.dart';
import 'package:task_management/view_models/theme_view_model.dart';
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
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskViewModelProvider);
    final sortBy = ref.watch(sortPrefViewModelProvider);
    isDarkMode = ref.watch(themeViewModelProvider);
    // Check screen width
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        actions: [
          // Sorting Popup
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
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
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final task = tasks[index];

        /*return TaskTile(
          task: task,
          onDelete: () {
            ref.read(taskViewModelProvider.notifier).removeTask(task.id);
          },
          onToggle: () {
            ref.read(taskViewModelProvider.notifier).toggleTask(task.id);
          },
          onTap: () {
            selectedTask = task;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsSection(task: selectedTask!),
                ));
          },
        );*/

        return GestureDetector(
          onTap: () {
            selectedTask = task;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsSection(task: selectedTask!),
                ));
          },
          child: Dismissible(
            key: Key("${index - 1}"),
            child: Container(
              height: 74,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: isDarkMode ? Colors.white : Colors.black),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Center(
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(task.isCompleted
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        onPressed: () {
                          ref
                              .read(taskViewModelProvider.notifier)
                              .toggleTask(task.id);
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 8,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  task.priority.name.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: task.priority == TaskPriority.high
                                        ? Colors.red
                                        : task.priority == TaskPriority.medium
                                            ? Colors.orange
                                            : Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                            Text(
                              "${task.date.day}/${task.date.month}/${task.date.year}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              // Edit
              if (direction == DismissDirection.startToEnd) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditTaskScreen(task: task),
                    ));
              }
              // Delete
              else if (direction == DismissDirection.endToStart) {
                _showDeleteDialog(context, ref, task);
              }
              return null;
            },
          ),
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref, TaskModel task) {
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
