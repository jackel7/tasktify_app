import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/screens/addTask_screen.dart';

class HomeScreen extends StatelessWidget {
  final String? email;
  final String? uid;
  const HomeScreen({
    super.key,
    required this.email,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Center(child: Text('$email ++ $uid')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddtaskScreen(),
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
