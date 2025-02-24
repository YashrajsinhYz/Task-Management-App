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
  // key for text field
  final GlobalKey dropdownKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    if (widget.task != null) {
      selectedPriority = widget.task!.priority; // Set existing priority
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.task == null ? "Add New" : "Edit"} Task"),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(22))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Title", style: TextStyle(fontSize: 22)),
            // Title
            TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Add Task Title",
              ),
            ),
            SizedBox(height: 15),

            Text("Description", style: TextStyle(fontSize: 22)),
            // Description
            TextField(
              maxLines: 4,
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Add Description",
              ),
            ),

            SizedBox(height: 15),
            Text("Priority", style: TextStyle(fontSize: 22)),
            // Priority Dropdown
            DropdownButtonFormField<TaskPriority>(
              key: dropdownKey,
              value: selectedPriority,
              decoration: InputDecoration(border: OutlineInputBorder()),
              items: TaskPriority.values.map((priority) {
                // calculate the width of the text field for the option builder width
                /*final RenderBox renderBox = dropdownKey.currentContext!.findRenderObject() as RenderBox;
                final double width = renderBox.size.width;*/
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Add Task Button
      floatingActionButton: ElevatedButton(
        child: Text(
          "${widget.task == null ? "Add" : "Save"} Task",
          style: TextStyle(fontSize: 18),
        ),
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
            fixedSize: WidgetStatePropertyAll(
                Size(MediaQuery.of(context).size.width - 30, 70))),
        onPressed: () {
          if (titleController.text.isNotEmpty &&
              descriptionController.text.isNotEmpty) {
            final taskProvider = ref.read(taskViewModelProvider.notifier);

            widget.task == null
                ? taskProvider.addTask(titleController.text,
                    descriptionController.text, selectedPriority)
                : taskProvider.updateTask(widget.task!.id, titleController.text,
                    descriptionController.text, selectedPriority);

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
