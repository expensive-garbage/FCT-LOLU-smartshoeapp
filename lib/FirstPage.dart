import 'package:flutter/material.dart';
import 'package:namer_app/Login.dart';
import 'package:namer_app/Signup.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      const First(),
      const Login(),
      const Signup()
    ];

    return Scaffold(
      body: _children[context.watch<MyAppState>().indexFirstPage],
    );
  }
}

class First extends StatelessWidget {
  const First({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  appState.changeIndexFirstPage(1);
                },
                child: const Text("Log in")),
            ElevatedButton(
                onPressed: () {
                  appState.changeIndexFirstPage(2);
                },
                child: const Text("Sign up")),
          ],
        ),
      ),
    );
  }
}
