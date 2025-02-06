import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/utility/database_helper.dart';

final taskViewModelProvider =
    StateNotifierProvider<TaskViewModel, List<TaskModel>>(
  (ref) => TaskViewModel(),
);

class TaskViewModel extends StateNotifier<List<TaskModel>> {
  TaskViewModel() : super([]) {
    // Load tasks when ViewModel initializes
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await DatabaseHelper.fetchTasks();
    state = tasks;
  }

  // Add Task
  Future<void> addTask(String title, String description) async {
    final newTask = TaskModel(id: 0, title: title, description: description);

    int id = await DatabaseHelper.insertTask(newTask);

    // Use actual SQLite ID & Update state
    state = [...state, newTask.copyWith(id: id)];
  }

  Future<void> updateTask(int id, String newTitle, String newDescription) async {
    await DatabaseHelper.updateTask(id, newTitle, newDescription);

    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(title: newTitle, description: newDescription);
      }
      return task;
    }).toList();
  }

  // Remove Task
  Future<void> removeTask(int id) async {
    await DatabaseHelper.deleteTask(id);

    state = state.where((task) => task.id != id).toList();
  }

  // Toggle Task Completion
  Future<void> toggleTask(int id) async {
    final task = state.firstWhere((task) => task.id == id);

    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    
    await DatabaseHelper.updateTaskStatus(id, updatedTask.isCompleted);

    state = state.map((task) => task.id == id ? updatedTask : task
      /*{
      return task.id == id
          ? TaskModel(
              id: task.id,
              title: task.title,
              isCompleted: !task.isCompleted,
              description: task.description)
          : task;
    }*/).toList();
  }
}
