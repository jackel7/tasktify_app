import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/screens/login_screen.dart';
import 'package:taskify/services/auth_service.dart';
import 'package:taskify/widgets/myButton.dart';
import 'package:taskify/widgets/myToast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final userNameController =
      TextEditingController();
  bool loading = false;
  bool obscure = true;

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 26),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.buttonText,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 200),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller:
                          userNameController,
                      decoration: InputDecoration(
                        hintText: 'User Name',
                        prefixIcon: const Icon(
                          Icons.person,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    10,
                                  ),
                              borderSide:
                                  const BorderSide(
                                    color: Colors
                                        .blue,
                                    width: 2,
                                  ),
                            ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Please enter user name";
                        }
                        if (userNameController
                                    .text
                                    .length <
                                6 ||
                            userNameController
                                    .text
                                    .length >
                                12) {
                          return "Username must be between 6 and 12 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    10,
                                  ),
                              borderSide:
                                  const BorderSide(
                                    color: Colors
                                        .blue,
                                    width: 2,
                                  ),
                            ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Please enter email";
                        }
                        if (!value.contains(
                          '@',
                        )) {
                          return "Enter A valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: obscure,
                      controller: passController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            obscure = !obscure;
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.visibility_off,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    10,
                                  ),
                              borderSide:
                                  const BorderSide(
                                    color: Colors
                                        .blue,
                                    width: 2,
                                  ),
                            ),
                      ),

                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Enter password';
                        }
                        if (value.length < 6) {
                          return 'Password cannot be less than 6 char';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 110),

              Mybutton(
                text: "Sign Up",
                isLoading: loading,
                onTap: () async {
                  if (_formKey.currentState!
                      .validate()) {
                    setState(() {
                      loading = true;
                    });
                  }
                  try {
                    UserCredential
                    userCredential =
                        await _authService.signUp(
                          email: emailController
                              .text
                              .trim(),
                          password: passController
                              .text
                              .trim(),
                        );

                    String uid =
                        userCredential.user!.uid;
                    await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(uid)
                        .set({
                          'uid': uid,
                          'userName':
                              userNameController
                                  .text
                                  .trim(),
                          'email': emailController
                              .text
                              .trim(),
                          'createdAt':
                              FieldValue.serverTimestamp(),
                        });

                    Toast.showToast(
                      context,
                      "Sign Up succesfull",
                    );

                    Future.delayed(
                      const Duration(seconds: 2),
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginScreen(),
                          ),
                        );
                      },
                    );
                  } catch (e) {
                    Toast.showToast(
                      context,
                      e.toString(),
                      isError: true,
                    );
                  } finally {
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
