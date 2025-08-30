import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/screens/addTask_screen.dart';
import 'package:taskify/screens/login_screen.dart';
import 'package:taskify/screens/updateTask_screen.dart';
import 'dart:io';

import 'package:taskify/widgets/myToast.dart'; // for exit()

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
  String userName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fetchUserName() async {
    final userdoc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(widget.uid)
        .get();
    setState(() {
      userName = userdoc.exists
          ? userdoc['userName']
          : 'User';
    });
  }

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
    final taskCollection = FirebaseFirestore
        .instance
        .collection('users')
        .doc(widget.uid)
        .collection('tasks');
    final user =
        FirebaseAuth.instance.currentUser;
    final FocusNode focusNode = FocusNode();

    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uid)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("Welcome...");
              }
              final data =
                  snapshot.data!.data()
                      as Map<String, dynamic>;
              return Text(
                "Welcome, ${data['userName'] ?? 'User'}",
                style: const TextStyle(
                  fontSize: 26,
                ),
              );
            },
          ),
          backgroundColor: AppColors.appBar,
          foregroundColor: AppColors.buttonText,
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance
                    .signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginScreen(),
                  ),
                );
              },
              icon: Icon(Icons.logout, size: 30),
            ),
            const SizedBox(width: 10),
          ],
        ),

        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextFormField(
                // focusNode: _focusNode,
                // onTapOutside: (event) {
                //   // Dismiss keyboard when tapping outside
                //   _focusNode.unfocus();
                // },
                controller: searchController,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Search',
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
                onChanged: (value) {
                  setState(
                    () {},
                  ); // rebuild to filter items
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: taskCollection
                    .orderBy(
                      'createdAt',
                      descending: true,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Text(
                      "No Tasks added yet!",
                    );
                  }

                  final tasks = snapshot
                      .data!
                      .docs
                      .map(
                        (doc) =>
                            Task.fromDocument(
                              doc,
                            ),
                      )
                      .toList();

                  final filteredTasks =
                      tasks.where((task) {
                        final query =
                            searchController.text
                                .toLowerCase()
                                .trim();
                        return task.title
                                .toLowerCase()
                                .contains(
                                  query,
                                ) ||
                            task.task
                                .toLowerCase()
                                .contains(query);
                      }).toList()..sort(
                        (a, b) =>
                            a.isDone == b.isDone
                            ? 0
                            : a.isDone
                            ? 1
                            : -1,
                      );

                  if (filteredTasks.isEmpty) {
                    return const Center(
                      child: Text(
                        "No tasks found.",
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount:
                        filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task =
                          filteredTasks[index];
                      return Card(
                        elevation: 3,
                        margin:
                            const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 10,
                            ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: task.isDone
                                ? Colors.grey
                                : getPriorityColor(
                                    task.priority,
                                  ),
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                        ),
                        child: ListTile(
                          horizontalTitleGap: 1,
                          contentPadding:
                              const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 1,
                              ),
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (value) {
                              taskCollection
                                  .doc(task.id)
                                  .update(({
                                    'isDone':
                                        value,
                                  }));
                              if (value == true) {
                                Toast.showToast(
                                  context,
                                  "Task Completed!",
                                );
                              } else {
                                Toast.showToast(
                                  context,
                                  "Task marked as incomplete",
                                );
                              }
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                              decoration:
                                  task.isDone
                                  ? TextDecoration
                                        .lineThrough
                                  : null,
                              color: task.isDone
                                  ? Colors.grey
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                task.task,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors
                                      .black
                                      .withOpacity(
                                        0.75,
                                      ),
                                  decoration:
                                      task.isDone
                                      ? TextDecoration
                                            .lineThrough
                                      : null,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text:
                                      "Priority: ",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: task
                                          .priority,
                                      style: TextStyle(
                                        color:
                                            task.isDone
                                            ? Colors.grey
                                            : getPriorityColor(
                                                task.priority,
                                              ),
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "Status: ${task.isDone ? " Done" : " Pending"}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  color:
                                      task.isDone
                                      ? Colors
                                            .green
                                      : Colors
                                            .redAccent,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            icon: const Icon(
                              Icons.more_vert,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdatetaskScreen(
                                        taskId: task
                                            .id!,
                                        title: task
                                            .title,
                                        priority:
                                            task.priority,
                                        task: task
                                            .task,
                                        isDone: task
                                            .isDone,
                                      ),
                                    ),
                                  );
                                },
                                child: const ListTile(
                                  leading: Icon(
                                    Icons.edit,
                                  ),
                                  title: Text(
                                    '   Edit    ',
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () async {
                                  await taskCollection
                                      .doc(
                                        task.id,
                                      )
                                      .delete();

                                  Toast.showToast(
                                    context,
                                    "Task Deleted!",
                                  );
                                },
                                value: 2,
                                child: const ListTile(
                                  leading: Icon(
                                    Icons
                                        .delete_outlined,
                                  ),
                                  title: Text(
                                    '   Delete    ',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton:
            FloatingActionButton(
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
              backgroundColor:
                  AppColors.textPrimary,
              child: const Icon(
                Icons.add,
                size: 28,
                color: AppColors.button,
              ),
            ),
      ),
    );
  }
}
