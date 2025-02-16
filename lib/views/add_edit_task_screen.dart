import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/view_models/task_view_model.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  TaskPriority selectedPriority = TaskPriority.medium; // Default Priority

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController = TextEditingController(text: widget.task?.description ?? '');
    if (widget.task != null) {
      selectedPriority = widget.task!.priority; // Set existing priority
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.task == null ? "Add" : "Edit"} Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Title", border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 4,
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),

            // Priority Dropdown
            DropdownButtonFormField<TaskPriority>(
              value: selectedPriority,
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              child: Text("${widget.task == null ? "Add" : "Edit"} Task"),
              onPressed: () {
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  final taskProvider = ref.read(taskViewModelProvider.notifier);

                  widget.task == null
                      ? taskProvider.addTask(titleController.text, descriptionController.text, selectedPriority)
                      : taskProvider.updateTask(widget.task!.id, titleController.text, descriptionController.text, selectedPriority);

                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

