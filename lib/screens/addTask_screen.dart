import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/widgets/myButton.dart';

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
  final List<String> priorities = [
    "High",
    "Medium",
    "Low",
  ];
  String selectedPriority = "Medium"; // default
  final Map<String, Color> priorityColors = {
    "High": AppColors.highPriority,
    "Medium": AppColors.mediumPriority,
    "Low": AppColors.lowPriority,
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
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
