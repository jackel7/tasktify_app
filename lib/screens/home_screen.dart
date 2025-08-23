import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/screens/addTask_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? email;
  final String? uid;

  const HomeScreen({
    super.key,
    required this.email,
    required this.uid,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController =
      TextEditingController();

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFF8E24AA);
      case 'medium':
        return const Color(0xFFD81B60);
      case 'low':
        return const Color(0xFF00ACC1);
      default:
        return const Color(0xFFB0BEC5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference _dbref =
        FirebaseDatabase.instance.ref().child(
          'users',
        );
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Taskify",
          style: TextStyle(fontSize: 26),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.buttonText,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextFormField(
              controller: searchController,
              textCapitalization:
                  TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(
                  () {},
                ); // rebuild to filter items
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: _dbref
                  .child(user!.uid)
                  .child('tasks'),
              defaultChild: const Center(
                child:
                    CircularProgressIndicator(),
              ),
              itemBuilder: (context, snapshot, animation, index) {
                final title =
                    snapshot
                        .child('title')
                        .value
                        ?.toString() ??
                    "No title";
                final description =
                    snapshot
                        .child('description')
                        .value
                        ?.toString() ??
                    '';
                final priority =
                    snapshot
                        .child('priority')
                        .value
                        ?.toString() ??
                    "Medium";

                // Filter items based on search
                if (searchController
                        .text
                        .isNotEmpty &&
                    !title.toLowerCase().contains(
                      searchController.text
                          .trim()
                          .toLowerCase(),
                    )) {
                  return const SizedBox.shrink();
                }

                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: getPriorityColor(
                        priority,
                      ),
                      width: 2,
                    ),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 10,
                          right: 2,
                        ),
                    horizontalTitleGap: 8,
                    leading: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: getPriorityColor(
                          priority,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                getPriorityColor(
                                  priority,
                                ),
                            blurRadius: 4,
                            offset: const Offset(
                              1,
                              1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.black
                                .withOpacity(
                                  0.75,
                                ),
                            fontSize: 15,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Priority: ",
                            style:
                                const TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                            children: [
                              TextSpan(
                                text: priority,
                                style: TextStyle(
                                  color:
                                      getPriorityColor(
                                        priority,
                                      ),
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {},
                          value: 1,
                          child: const ListTile(
                            leading: Icon(
                              Icons.edit,
                            ),
                            title: Text(
                              "   Edit   ",
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            final taskId = snapshot
                                .key; // or pass it directly if you already have it
                            if (taskId != null) {
                              FirebaseDatabase
                                  .instance
                                  .ref()
                                  .child('users')
                                  .child(
                                    user!.uid,
                                  )
                                  .child('tasks')
                                  .child(taskId)
                                  .remove(); // deletes only this task
                            }
                          },
                          value: 2,
                          child: const ListTile(
                            leading: Icon(
                              Icons.delete,
                            ),
                            title: Text(
                              "   delete  ",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AddtaskScreen(),
            ),
          );
        },
        tooltip: 'Add new task',
        backgroundColor: AppColors.textPrimary,
        child: const Icon(
          Icons.add,
          size: 28,
          color: AppColors.button,
        ),
      ),
    );
  }
}
