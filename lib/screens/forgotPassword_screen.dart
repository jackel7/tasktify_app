import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/services/auth_service.dart';
import 'package:taskify/widgets/myButton.dart';
import 'package:taskify/widgets/myToast.dart';

class ForgotpasswordScreen
    extends StatefulWidget {
  const ForgotpasswordScreen({super.key});

  @override
  State<ForgotpasswordScreen> createState() =>
      _ForgotpasswordScreenState();
}

class _ForgotpasswordScreenState
    extends State<ForgotpasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final FirebaseAuth _auth =
      FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
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
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center,

          children: [
            const SizedBox(height: 90),

            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType:
                    TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                  ),
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
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Please enter email";
                  }
                  if (!value.contains('@')) {
                    return "Enter A valid email";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 90),
            Mybutton(
              text: "Send",
              isLoading: loading,
              onTap: () async {
                if (_formKey.currentState!
                    .validate()) {
                  setState(() {
                    loading = true;
                  });

                  try {
                    await _auth
                        .sendPasswordResetEmail(
                          email: emailController
                              .text
                              .trim(),
                        );
                    Toast.showToast(
                      context,
                      "Password reset email sent! Please check your inbox",
                    );
                    emailController.clear();
                  } catch (e) {
                    Toast.showToast(
                      context,
                      "Something went wrong. Please try again later!",
                      isError: true,
                    );
                  } finally {
                    setState(() {
                      loading = false;
                    });
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
