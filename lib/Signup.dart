import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  _SignupState();
  File? _imageFile;

  Future<String> uploadImage() async {
    if (_imageFile != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref();
        Reference? imagesRef = storageRef
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        // Uploader le fichier sur Firebase Storage
        await imagesRef.putFile(_imageFile!);

        // Récupérer l'URL de téléchargement de l'image
        String downloadURL = await imagesRef.getDownloadURL();

        // Faire quelque chose avec l'URL de téléchargement, comme l'afficher dans l'application
        print('Image uploaded: $downloadURL');
        return downloadURL;
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    }
    return '';
  }

  CollectionReference user = FirebaseFirestore.instance.collection('user');
  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();
  final myNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myEmailController.dispose();
    myPasswordController.dispose();
    myNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var emailAddress = '';
    var password = '';
    var name = '';
    var photoURL = '';
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 200,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: _getImage,
                        child: _imageFile == null
                            ? const Text('Add a profile image')
                            : Image.file(_imageFile!),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: myNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'John Doe'),
                  ),
                ),
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
                    controller: myPasswordController,
                    obscureText: true,
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
                          name = myNameController.text;
                          photoURL = await uploadImage();
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailAddress,
                              password: password,
                            );
                            user.doc(credential.user!.uid).set({
                              'PhotoURL': photoURL,
                              'Name': name,
                              'Temperature Threshold': 20,
                              'Humidity Rate Threshold': 60,
                            }).then((value) {
                              print('Document ajouté avec succès');
                            }).catchError((error) {
                              print(
                                  'Erreur lors de l\'ajout du document: $error');
                            });
                            Navigator.pushNamed(context, '/home');
                            appState.changeIndexFirstPage(0);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password' ||
                                e.code == 'email-already-in-use') {
                              print('The password provided is too weak.');
                              print(
                                  'The account already exists for that email.');
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context),
                              );
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text("Sign up"))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Authentification failed'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text("already used email or weak password."),
      ],
    ),
    actions: <Widget>[
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}
