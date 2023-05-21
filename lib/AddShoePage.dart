import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

class AddShoePage extends StatefulWidget {
  const AddShoePage({super.key});

  @override
  State<AddShoePage> createState() => _AddShoePageState();
}

class _AddShoePageState extends State<AddShoePage> {
  String error = '';
  List<bool> _seasonSelected = [false, false, false, false];
  List<bool> _colorSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  bool _isWaterproof = false;
  final List<String> _seasons = ['Winter', 'Spring', 'Summer', 'Fall'];
  final List<String> _colors = [
    'Red',
    'Green',
    'Blue',
    'Yellow',
    'Black',
    'White',
    'Grey',
    'Orange',
    'Pink',
    'Other'
  ];
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

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = '';
    if (user != null) {
      uid = user.uid;
      print('L\'UID de l\'utilisateur est: $uid');
    } else {
      print('Aucun utilisateur n\'est actuellement authentifié.');
    }

    var photoURL = '';

    final TextEditingController nameController = TextEditingController();
    final TextEditingController brandController = TextEditingController();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: _getImage,
                  child: _imageFile == null
                      ? const Text('image of the shoe')
                      : Image.file(_imageFile!),
                ),
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Running shoes n°1'),
            ),
            TextField(
              controller: brandController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Brand',
                  hintText: 'Veja'),
            ),
            const Text("Seasons"),
            ToggleButtons(
              isSelected: _seasonSelected,
              onPressed: (int index) {
                setState(() {
                  _seasonSelected[index] = !_seasonSelected[index];
                });
              },
              children: _seasons.map((season) => Text(season)).toList(),
            ),
            const Text('This shoe is :'),
            ElevatedButton(
              child: Text(_isWaterproof ? 'Waterproof' : 'Not Waterproof'),
              onPressed: () {
                setState(() {
                  _isWaterproof = !_isWaterproof;
                });
              },
            ),
            const Text("Colors"),
            Wrap(
              children: _colors
                  .asMap()
                  .map((index, color) => MapEntry(
                      index,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _colorSelected[index]
                                ? const Color.fromARGB(255, 246, 144, 121)
                                : null,
                          ),
                          onPressed: () {
                            setState(() {
                              _colorSelected[index] = !_colorSelected[index];
                            });
                          },
                          child: Text(color),
                        ),
                      )))
                  .values
                  .toList(),
            ),
            const Text('Type'),
            DropdownButton<String>(
              value: 'Sneaker',
              onChanged: (String? newValue) {
                setState(() {});
              },
              items: <String>[
                'Sneaker',
                'Boot',
                'Espadrille',
                'Hiking Boot',
                'Other'
              ].toList().map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Text(error, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
                onPressed: () async {
                  photoURL = await uploadImage();
                  List<String?> filteredSeasons = _seasons
                      .asMap()
                      .map((index, season) {
                        if (_seasonSelected[index]) {
                          return MapEntry(index, season);
                        } else {
                          return MapEntry(index, null);
                        }
                      })
                      .values
                      .where((season) => season != null)
                      .toList();

                  List<String?> filteredColors = _colors
                      .asMap()
                      .map((index, color) {
                        if (_colorSelected[index]) {
                          return MapEntry(index, color);
                        } else {
                          return MapEntry(index, null);
                        }
                      })
                      .values
                      .where((color) => color != null)
                      .toList();

                  if (nameController.text == '' || brandController.text == '') {
                    error = 'Please fill all the fields';
                    appState.changeIndexMyHomePage(3);
                    return;
                  }
                  if (filteredSeasons.isEmpty || filteredColors.isEmpty) {
                    error = 'Please select at least one color and one season';
                    appState.changeIndexMyHomePage(3);
                    return;
                  }
                  FirebaseFirestore.instance.collection('shoe').doc().set({
                    'Name': nameController.text,
                    'Brand': brandController.text,
                    'Seasons': filteredSeasons,
                    'Waterproof': _isWaterproof,
                    'Colors': filteredColors,
                    'Type': 'Sneaker',
                    'PhotoURL': photoURL,
                    'IdUser': uid,
                    'DateLastWorn': DateTime.now(),
                  }).then((value) {
                    appState.changeIndexMyHomePage(1);
                    print('Document ajouté avec succès');
                  }).catchError((error) {
                    print('Erreur lors de l\'ajout du document: $error');
                  });
                },
                child: const Text('Add Shoe')),
          ],
        ),
      ),
    );
  }
}
