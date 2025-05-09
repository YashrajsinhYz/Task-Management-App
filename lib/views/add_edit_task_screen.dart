import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/utility/app_theme.dart';
import 'package:task_management/view_models/task_view_model.dart';
import 'package:task_management/view_models/theme_view_model.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  String dueDays = "";
  DateTime? selectedDate;
  String selectedDateString = "";
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  TaskPriority selectedPriority = TaskPriority.medium; // Default Priority
  // key for text field
  final GlobalKey dropdownKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // selectedDate = DateTime.now();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    if (widget.task != null) {
      selectedPriority = widget.task!.priority; // Set existing priority
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.task == null ? "Add New" : "Edit"} Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
              // Title
              TextField(
                controller: titleController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                cursorColor: isDarkMode ? Colors.white : null,
                decoration: InputDecoration(
                    hintText: "Task Title",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 15),

              Text("Description",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // Description
              TextField(
                maxLines: 4,
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: isDarkMode ? Colors.white : null,
                decoration: InputDecoration(
                    hintText: "Task Description",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),

              SizedBox(height: 15),
              Text("Priority", style: TextStyle(fontWeight: FontWeight.bold)),
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

              SizedBox(height: 15),
              /*Text("Due Date", style: TextStyle(fontWeight: FontWeight.bold)),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(primaryColor.withAlpha(20)),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                ),
                onPressed: pickDueDate,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedDate == null
                        ? "Select Due Date"
                        : "$selectedDateString ($dueDays days)",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Add Task Button
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            fixedSize: WidgetStatePropertyAll(
                Size(MediaQuery.of(context).size.width - 30, 60))),
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
        child: Text(
          "${widget.task == null ? "Add" : "Update"} Task",
        ),
      ),
    );
  }

  Future pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      selectedDate = pickedDate;
      dueDays = "${selectedDate!.difference(DateTime.now()).inDays + 1}";
      selectedDateString =
          "${selectedDate?.day.toString().padLeft(2, '0')}/${selectedDate?.month.toString().padLeft(2, '0')}/${selectedDate?.year}";
    }
  }
}
