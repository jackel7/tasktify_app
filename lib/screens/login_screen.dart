import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/constants/colors.dart';
import 'package:taskify/screens/home_screen.dart';
import 'package:taskify/screens/signUp_screen.dart';
import 'package:taskify/services/auth_service.dart';
import 'package:taskify/widgets/myButton.dart';
import 'package:taskify/widgets/myToast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool loading = false;
  final AuthService _authService = AuthService();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(fontSize: 26),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: AppColors.buttonText,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                      keyboardType: TextInputType
                          .emailAddress,
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
                      keyboardType:
                          TextInputType.text,
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
                          icon: Icon(
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
                          return 'Password cannot be less than 6 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 110),

              Mybutton(
                text: "Login",
                isLoading: loading,
                onTap: () async {
                  if (_formKey.currentState!
                      .validate()) {
                    setState(() {
                      loading = true;
                    });
                    String? res =
                        await _authService.login(
                          email: emailController
                              .text
                              .trim(),
                          password: passController
                              .text
                              .trim(),
                        );
                    setState(() {
                      loading = false;
                    });
                    if (res == null) {
                      final user = FirebaseAuth
                          .instance
                          .currentUser;

                      Toast.showToast(
                        context,
                        'Login Successful!',
                      );
                      Future.delayed(
                        Duration(seconds: 2),
                        () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (
                                    context,
                                  ) => HomeScreen(
                                    email: user!
                                        .email,
                                    uid: user.uid,
                                  ),
                            ),
                          );
                        },
                      );
                    } else {
                      Toast.showToast(
                        context,
                        res,
                        isError: true,
                      );
                    }
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
                    "Don't have an account?",
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignupScreen(),
                        ),
                      );
                    },
                    child: const Text('Sign Up'),
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
