import 'package:dutch_quiz/pages/create_account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: 0.75,
                      child: SvgPicture.asset(
                        "images/dutch_logo.svg",
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      if (currentUser == null) {
                        return const Text('Test your knowledge...', style: TextStyle(fontSize: 48), textAlign: TextAlign.center,);
                      } else {
                        return Text('Welcome back, ${currentUser.displayName}', style: const TextStyle(fontSize: 48), textAlign: TextAlign.center,);
                      }
                    }
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (currentUser == null) {
                    return FractionallySizedBox(
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
                            const SizedBox(height: 10,),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
                                    setState(() {});
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'invalid-credential') {
                                      toastification.show(
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.fillColored,
                                        title: const Text('Invalid login credentials!'),
                                        alignment: Alignment.bottomCenter
                                      );
                                    } else {
                                      toastification.show(
                                        type: ToastificationType.error,
                                        style: ToastificationStyle.fillColored,
                                        title: Text(e.code),
                                        alignment: Alignment.bottomCenter
                                      );
                                    }
                                  }
                                }
                              }, 
                              child: const Text('Login')
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Text('wow you are already signed in!');
                  }
                }
              ),
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Create a new account', style: TextStyle(color: Colors.white, fontSize: 24),),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}