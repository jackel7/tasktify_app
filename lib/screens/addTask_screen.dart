import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/services/task_services.dart';
import 'package:taskify/widgets/myButton.dart';
import 'package:taskify/widgets/myToast.dart';

class AddtaskScreen extends StatefulWidget {
  const AddtaskScreen({super.key});

  @override
  State<AddtaskScreen> createState() =>
      _AddtaskScreenState();
}

class _AddtaskScreenState
    extends State<AddtaskScreen> {
  final taskTitleController =
      TextEditingController();
  final taskController = TextEditingController();
  bool loading = false;
  final List<String> priorities = [
    "High",
    "Medium",
    "Low",
  ];
  String selectedPriority = "Medium"; // default
  final Map<String, Color> priorityColors = {
    "High": const Color(0xFF8E24AA),
    "Medium": const Color(0xFFD81B60),
    "Low": const Color(0xFF00ACC1),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Task",
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
              const SizedBox(height: 150),
              Mybutton(
                text: "Save",
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
                  final newTask = Task(
                    title: title,
                    task: task,
                    priority: selectedPriority,
                    createdAt: DateTime.now()
                        .millisecondsSinceEpoch,
                    isDone: false,
                  );
                  try {
                    await TaskServices().addTask(
                      newTask,
                    );
                    print(
                      "Task added for user: ${FirebaseAuth.instance.currentUser?.uid}",
                    );

                    Toast.showToast(
                      context,
                      "Task Added!",
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
