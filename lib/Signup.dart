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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                          emailAddress = myEmailController.text;
                          password = myPasswordController.text;
                          name = myNameController.text;
                          photoURL = await uploadImage();
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailAddress,
                            password: password,
                          )
                              .then((UserCredential userCredential) {
                            // L'utilisateur s'est connecté avec succès
                            // Mettez ici votre logique de redirection vers la page principale, par exemple :
                            print('uid: ' + userCredential.user!.uid);
                            appState.uid = userCredential.user!.uid;
                            appState.changeIndexFirstPage(0);
                            Navigator.pop(context);
                            user.doc(appState.uid).set({
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
                          }).catchError((e) {
                            // Une erreur s'est produite lors de la connexion de l'utilisateur
                            // Gérez ici l'affichage d'un message d'erreur à l'utilisateur, par exemple :
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Erreur de connexion'),
                                content:
                                    const Text('Vérifiez vos identifiants.'),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
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
