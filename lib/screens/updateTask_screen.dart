import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/widgets/myButton.dart';
import 'package:taskify/widgets/myToast.dart';

class UpdatetaskScreen extends StatefulWidget {
  final String taskId;
  final String title;
  final String task;
  final String priority;
  final bool isDone;

  const UpdatetaskScreen({
    super.key,
    required this.taskId,
    required this.title,
    required this.priority,
    required this.task,
    required this.isDone,
  });

  @override
  State<UpdatetaskScreen> createState() =>
      _UpdatetaskScreenState();
}

class _UpdatetaskScreenState
    extends State<UpdatetaskScreen> {
  final taskTitleController =
      TextEditingController();
  final taskController = TextEditingController();
  bool loading = false;
  bool? isDone;
  final List<String> priorities = [
    "High",
    "Medium",
    "Low",
  ];
  late String selectedPriority; // default
  final Map<String, Color> priorityColors = {
    "High": const Color(0xFF8E24AA),
    "Medium": const Color(0xFFD81B60),
    "Low": const Color(0xFF00ACC1),
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskController.text = widget.task;
    taskTitleController.text = widget.title;
    selectedPriority = widget.priority;
    isDone = widget.isDone ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Task",
          style: TextStyle(fontSize: 26),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.buttonText,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                textCapitalization:
                    TextCapitalization.sentences,

                controller: taskTitleController,
                decoration: InputDecoration(
                  hintText: 'Add Title',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                        borderSide:
                            const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                      ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                textCapitalization:
                    TextCapitalization.sentences,
                maxLines: 5,
                controller: taskController,
                decoration: InputDecoration(
                  hintText: 'Add Task',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                        borderSide:
                            const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                      ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  const Text(
                    "Priority: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Wrap(
                    spacing: 7,
                    children: priorities.map((
                      priority,
                    ) {
                      final isSelected =
                          selectedPriority ==
                          priority;
                      return ChoiceChip(
                        label: Text(
                          priority,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor:
                            priorityColors[priority],
                        backgroundColor:
                            priorityColors[priority]!
                                .withOpacity(0.6),
                        onSelected: (selected) {
                          setState(() {
                            selectedPriority =
                                priority;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              // Inside Column, after Priority row and before SizedBox(height: 150)
              Row(
                children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          AppColors.textPrimary,
                    ),
                  ),
                  Checkbox(
                    value: isDone,
                    onChanged: (value) {
                      setState(() {
                        isDone =
                            value ??
                            false; // safe
                      });
                    },
                  ),
                  Text(
                    isDone! ? "Done" : "Pending",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDone!
                          ? Colors.green
                          : Colors.redAccent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 150),
              Mybutton(
                text: "Update",
                isLoading: loading,
                onTap: () async {
                  final title =
                      taskTitleController.text
                          .trim();
                  final task = taskController.text
                      .trim();

                  if (title.isEmpty ||
                      task.isEmpty) {
                    Toast.showToast(
                      context,
                      "Please enter data",
                      isError: true,
                    );
                    return;
                  }
                  setState(() {
                    loading = true;
                  });
                  final updatedTask = Task(
                    id: widget.taskId,
                    title: taskTitleController
                        .text
                        .trim(),
                    task: taskController.text
                        .trim(),
                    priority: selectedPriority,
                    createdAt: DateTime.now()
                        .millisecondsSinceEpoch,
                    isDone: isDone ?? false,
                  );
                  final userId = FirebaseAuth
                      .instance
                      .currentUser!
                      .uid;
                  try {
                    await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(userId)
                        .collection('tasks')
                        .doc(widget.taskId)
                        .set(updatedTask.toMap());
                    Toast.showToast(
                      context,
                      "Task Updated!",
                    );
                    Future.delayed(
                      const Duration(seconds: 2),
                      () {
                        Navigator.pop(context);
                      },
                    );
                    taskController.clear();
                    taskTitleController.clear();
                  } catch (e) {
                    Toast.showToast(
                      context,
                      e.toString(),
                    );
                  } finally {
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
