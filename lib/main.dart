import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dutch_quiz/firebase_options.dart';
import 'package:dutch_quiz/pages/home_page.dart';
import 'package:dutch_quiz/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: Colors.blue, dynamicSchemeVariant: DynamicSchemeVariant.vibrant);

    return ToastificationWrapper(
      child: MaterialApp(
        title: "Dutch Quiz",
        theme: ThemeData.from(
          colorScheme: scheme,
        ).copyWith(
          textTheme: GoogleFonts.robotoMonoTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: scheme.primary
          )
        ),
        home: Builder(
          builder: (context) {
            if (FirebaseAuth.instance.currentUser != null) {
              return const HomePage();
            } else {
              return const SignInPage();
            }
          }
        ),
      ),
    );
  }
}
