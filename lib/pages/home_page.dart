import 'package:dutch_quiz/pages/sign_in_page.dart';
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
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'images/dutch_logo.svg',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        title: const Text('Dutch Quiz', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                toastification.show(
                  type: ToastificationType.success,
                  style: ToastificationStyle.fillColored,
                  title: const Text('Signed out!'),
                  alignment: Alignment.bottomCenter,
                  autoCloseDuration: const Duration(seconds: 5)
                );
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
              }, 
              child: const Text('Sign out')
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome back, ${currentUser!.displayName}', style: const TextStyle(fontSize: 48))
          ],
        ),
      ),
    );
  }
}