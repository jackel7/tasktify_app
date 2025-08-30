import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/screens/addTask_screen.dart';
import 'package:taskify/screens/login_screen.dart';
import 'package:taskify/screens/updateTask_screen.dart';
import 'dart:io';

import 'package:taskify/widgets/myToast.dart'; // for exit()

class FirestoreListscreen extends StatefulWidget {
  const FirestoreListscreen({super.key});

  @override
  State<FirestoreListscreen> createState() =>
      _FirestoreListscreenState();
}

class _FirestoreListscreenState
    extends State<FirestoreListscreen> {
  final searchController =
      TextEditingController();
  final firestore = FirebaseFirestore.instance
      .collection('users')
      .snapshots();
  CollectionReference ref = FirebaseFirestore
      .instance
      .collection('users');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Taskify  firestore",
            style: TextStyle(fontSize: 26),
          ),
          backgroundColor: AppColors.appBar,
          foregroundColor: AppColors.buttonText,
          centerTitle: true,
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
              icon: const Icon(
                Icons.logout,
                size: 30,
              ),
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
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot>
                    snapshot,
                  ) {
                    if (snapshot
                            .connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text("error");
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot
                            .data!
                            .docs
                            .length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              ref
                                  .doc(
                                    snapshot
                                        .data!
                                        .docs[index]
                                        .id
                                        .toString(),
                                  )
                                  .delete()
                                  .then((value) {
                                    Toast.showToast(
                                      context,
                                      "delete",
                                    );
                                  })
                                  .onError((
                                    error,
                                    stackTrace,
                                  ) {
                                    Toast.showToast(
                                      context,
                                      'error while updating $error',
                                    );
                                  });
                            },
                            title: Text(
                              snapshot
                                  .data!
                                  .docs[index]['title']
                                  .toString(),
                            ),
                            subtitle: Text(
                              snapshot
                                  .data!
                                  .docs[index]['id']
                                  .toString(),
                            ),
                          );
                        },
                      ),
                    );
                  },
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
