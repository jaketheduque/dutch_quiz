import 'dart:convert';

import 'package:dutch_quiz/data/flavor.dart';
import 'package:dutch_quiz/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';

class FlavorsPage extends StatefulWidget {
  @override
  State<FlavorsPage> createState() => _FlavorsPageState();
}

class _FlavorsPageState extends State<FlavorsPage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
    }

    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString("assets/json/flavors.json"), 
      builder: (context, snapshot) {
        final flavors = jsonDecode(snapshot.data!) as List<dynamic>;

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

                    if (!context.mounted) return;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
                  }, 
                  child: const Text('Sign out')
                ),
              )
            ],
          ),
          body: Center(
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(hintText: 'Search'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ...flavors
                        .map((flavor) {
                          return Flavor.fromJson(flavor);
                        })
                        .where((flavor) {
                          return flavor.name.toUpperCase().contains(searchController.text.toUpperCase());
                        })
                        .map((flavor) {
                          return ExpansionTile(
                            title: Center(child: Text(flavor.name)),
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    const TextSpan(
                                      text: 'Toppings: ',
                                      style: TextStyle(fontWeight: FontWeight.bold)
                                    ),
                                    TextSpan(
                                      text: flavor.toppings?.join(', ') == '' ? 'None' : flavor.toppings?.join(', ')
                                    )
                                  ]
                                )
                              ),
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    const TextSpan(
                                      text: 'Ingredients: ',
                                      style: TextStyle(fontWeight: FontWeight.bold)
                                    ),
                                    TextSpan(
                                      text: flavor.ingredients.join(', ')
                                    )
                                  ]
                                )
                              )
                            ],
                          );
                        })
                    ]
                  ),
                ),
              ],
            )
          )
        );
  }
    );
  }
}