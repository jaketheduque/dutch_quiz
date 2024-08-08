import 'package:dutch_quiz/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Create your account!', style: TextStyle(fontSize: 48), textAlign: TextAlign.center,),
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'Please enter an email address';
                              }
                  
                              final bool emailValid = 
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value);
                  
                              if (!emailValid) {
                                return 'Please enter a valid email address';
                              }
                  
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(labelText: 'Username'),
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'Please enter a username';
                              }
                  
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Confirm Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value == "") {
                                return 'Please confirm your passwrod';
                              } else if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10,),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
                                  if (FirebaseAuth.instance.currentUser != null) {
                                    FirebaseAuth.instance.currentUser!.updateDisplayName(usernameController.text.trim());
                                  }

                                  toastification.show(
                                    type: ToastificationType.success,
                                    style: ToastificationStyle.fillColored,
                                    title: const Text('Account created! Redirecting back to login page...'),
                                    alignment: Alignment.bottomCenter,
                                    autoCloseDuration: const Duration(seconds: 3)
                                  );

                                  await Future.delayed(const Duration(seconds: 3));
                                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => const HomePage()));
                                } on FirebaseAuthException catch (e) {
                                  switch (e.code) {
                                    case 'email-already-in-use': {
                                      toastification.show(
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.fillColored,
                                        title: const Text('Email already in use!'),
                                        alignment: Alignment.bottomCenter,
                                        autoCloseDuration: const Duration(seconds: 5)
                                      );
                                    }
                                    default: {
                                      toastification.show(
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.fillColored,
                                        title: Text(e.code),
                                        alignment: Alignment.bottomCenter,
                                        autoCloseDuration: const Duration(seconds: 5)
                                      );
                                    }
                                  }
                                }
                              }
                            },
                            child: const Text('Create account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        )
      ),
    );
  }
}