import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyApp.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final myEmailController = TextEditingController();

  final myPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myEmailController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var emailAddress = '';
    var password = '';
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: myEmailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'e-mail address',
                        hintText: 'abc@gmail.com'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    controller: myPasswordController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'password'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () async {
                          emailAddress = myEmailController.text;
                          password = myPasswordController.text;
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailAddress,
                            password: password,
                          )
                              .then((UserCredential userCredential) async {
                            // L'utilisateur s'est connecté avec succès
                            // Mettez ici votre logique de redirection vers la page principale, par exemple :
                            appState.checkiflogged();
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString(
                                'uid', userCredential.user!.uid);
                            final String? uid_saved = prefs.getString('uid');
                            print("in login");
                            print(uid_saved);
                            appState.changeIndexFirstPage(0);
                          }).catchError((e) {
                            // Une erreur s'est produite lors de la connexion de l'utilisateur
                            // Gérez ici l'affichage d'un message d'erreur à l'utilisateur, par exemple :
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Error of connexion'),
                                content: Text('Check your credentials'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                        child: const Text("Log in"))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
