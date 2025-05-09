import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/view_models/sort_pref_view_model.dart';
import 'package:task_management/view_models/task_view_model.dart';
import 'package:task_management/view_models/theme_view_model.dart';
import 'package:task_management/views/add_edit_task_screen.dart';
import 'package:task_management/views/task_details_section.dart';
import 'package:task_management/widgets/drawer_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeUiState();
}

class _HomeUiState extends ConsumerState<HomeScreen> {
  bool isTablet = false;
  bool isDarkMode = false;
  TaskModel? selectedTask; // For tablet view
  FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        ref.read(searchQueryProvider.notifier).state = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check screen width
    isTablet = MediaQuery.of(context).size.width > 600;
    final allTasks = ref.watch(taskViewModelProvider);
    final sortBy = ref.watch(sortPrefViewModelProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final filteredTasks = allTasks.where((task) {
      return task.title.toLowerCase().contains(searchQuery) ||
          task.description.toLowerCase().contains(searchQuery);
    }).toList();

    isDarkMode = ref.watch(themeViewModelProvider);
    return Scaffold(
      drawer: DrawerWidget(),
      drawerEnableOpenDragGesture: false,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            title: Text("Tasks", style: TextStyle(fontFamily: "Poppins")),
            actions: [
              // Sorting Popup
              PopupMenuButton(
                icon: Icon(Icons.filter_list),
                initialValue: sortBy,
                itemBuilder: (context) => [
                  PopupMenuItem(value: "date", child: Text("Sort by Date")),
                  PopupMenuItem(
                      value: "priority", child: Text("Sort by Priority")),
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
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(66),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SizedBox(
                  height: 56,
                  child: SearchBar(
                    focusNode: searchFocusNode,
                    controller: searchController,
                    hintText: "Search task...",
                    elevation: WidgetStatePropertyAll(0),
                    leading: Icon(CupertinoIcons.search, color: Colors.grey),
                    hintStyle:
                        WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
                    trailing: [
                      if (searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            ref.read(searchQueryProvider.notifier).state = "";
                          },
                        ),
                    ],
                    onTapOutside: (event) {
                      searchFocusNode.unfocus();
                    },
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey))),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: allTasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      // color: Colors.red,
                      margin: EdgeInsets.only(bottom: 10),
                      child: CircularProgressIndicator(),
                    ),
                    Text("Schedule your tasks",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                    Text("Manage your task schedule easily & efficiently",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 12)),
                  ],
                ),
              )
            : isTablet
                ? buildTabletView(filteredTasks)
                : buildMobileView(filteredTasks),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTaskScreen()),
          );
        },
      ),
    );
  }

  Widget buildMobileView(List<TaskModel> tasks) {
    return tasks.isEmpty
        ? Center(
            child: Text("No tasks found of given query."),
          )
        : ListView.builder(
            itemCount: tasks.length,
            padding: EdgeInsets.only(top: 5),
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return taskCard(taskData: task);
            },
          );
  }

  Widget taskCard({required TaskModel taskData}) {
    DateTime date = taskData.date;
    String dueDays = "${date.difference(DateTime.now()).inDays + 1}";
    String dateDisplayValue =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    return GestureDetector(
      onTap: () {
        selectedTask = taskData;
        // Show details panel :
        // Mobile => New Screen
        // Tablet => Side Panel
        if (!isTablet) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsSection(task: selectedTask!),
              ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
        child: Dismissible(
          key: Key("${taskData.id}"),
          confirmDismiss: (direction) async {
            // Edit
            if (direction == DismissDirection.startToEnd) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditTaskScreen(task: taskData),
                  ));
            }
            // Delete
            else if (direction == DismissDirection.endToStart) {
              _showDeleteDialog(context, ref, taskData);
            }
            return null;
          },
          background: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.only(left: 16.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: Text("Edit", style: TextStyle(color: Colors.white)),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: Text("Delete", style: TextStyle(color: Colors.white)),
          ),
          child: Card(
            // color: Colors.grey.shade50,
            // margin: EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        taskData.title,
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600),
                      ),
                      // options(taskId: taskData.id),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: taskData.priority == TaskPriority.high
                                ? Colors.red
                                : taskData.priority == TaskPriority.medium
                                    ? Colors.orange
                                    : Colors.green,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          taskData.priority.name.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    taskData.description,
                    style: TextStyle(
                        /*color: Colors.grey,*/
                        overflow: TextOverflow.ellipsis),
                    maxLines: 2,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey : Colors.grey.shade300,
                      borderRadius: BorderRadiusDirectional.circular(10),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    // Due Date & Pending Days
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: isDarkMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            dateDisplayValue,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: isDarkMode
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget options({required int taskId}) {
    return PopupMenuButton(
      iconSize: 20,
      style: ButtonStyle(visualDensity: VisualDensity.compact),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10)),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.edit_calendar, size: 24, color: Colors.black),
                SizedBox(width: 10),
                Text("Edit", style: TextStyle(color: Colors.black)),
              ],
            ),
            onTap: () {},
          ),
          PopupMenuItem(
            child: Row(
              children: [
                Icon(Icons.delete, size: 24, color: Colors.red),
                SizedBox(width: 10),
                Text("Delete", style: TextStyle(color: Colors.red))
              ],
            ),
            onTap: () {},
          )
        ];
      },
    );
  }

  // Tablet View: Split View with List & Details
  Widget buildTabletView(List<TaskModel> tasks) {
    return Row(
      children: [
        // Task List (Left Side)
        Expanded(
          child: buildMobileView(tasks),
        ),
        VerticalDivider(
          color: Colors.grey.shade300,
          indent: 24,
          endIndent: 24,
        ),
        // Task Details (Right Side)
        Expanded(
          child: selectedTask != null
              ? TaskDetailsSection(task: selectedTask!) // Show Task Details
              : Center(
                  child: Text(
                  "Select a task to view details",
                  style: TextStyle(color: Colors.grey),
                )),
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
