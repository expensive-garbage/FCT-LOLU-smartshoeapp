import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

class ChangeShoePage extends StatefulWidget {
  @override
  _ChangeShoePageState createState() => _ChangeShoePageState();
}

class _ChangeShoePageState extends State<ChangeShoePage> {
  final _formKey = GlobalKey<FormState>();

  List<String> _seasons = ['Spring', 'Summer', 'Fall', 'Winter'];
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

    var selectedSeasons = appState.seasonShoe;
    var selectedColors = appState.colorsShoe;
    List<bool> selectedSeasonsList = _seasons.map((season) {
      return selectedSeasons.contains(season);
    }).toList();
    List<bool> selectedColorsList = _colors.map((color) {
      return selectedColors.contains(color);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Shoe Name',
                ),
                initialValue: appState.nameShoe,
                validator: (value) {
                  if (value == "") {
                    return 'Please enter a shoe name';
                  }
                  return null;
                },
                onSaved: (value) {
                  appState.changeNameShoe(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Shoe Brand',
                ),
                initialValue: appState.brandShoe,
                validator: (value) {
                  if (value == "") {
                    return 'Please enter a shoe brand';
                  }
                  return null;
                },
                onSaved: (value) {
                  appState.changeBrandShoe(value!);
                },
              ),
              const SizedBox(height: 16),
              const Text('Select one or more seasons:'),
              ToggleButtons(
                isSelected: selectedSeasonsList,
                onPressed: (int index) {
                  setState(() {
                    selectedSeasonsList[index] = !selectedSeasonsList[index];
                    // Update appState.seasonShoe list based on selectedSeasonsList
                    if (selectedSeasonsList[index]) {
                      appState.seasonShoe.add(_seasons[index]);
                    } else {
                      appState.seasonShoe.remove(_seasons[index]);
                    }
                  });
                },
                children: _seasons.map((season) => Text(season)).toList(),
              ),
              const Text('This shoe is :'),
              ElevatedButton(
                child: Text(
                    appState.waterproofShoe ? 'Waterproof' : 'Not Waterproof'),
                onPressed: () {
                  setState(() {
                    appState.changeWaterproofShoe(!appState.waterproofShoe);
                  });
                },
              ),
              const Text("Colors:"),
              Wrap(
                children: _colors
                    .asMap()
                    .map((index, color) => MapEntry(
                          index,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedColorsList[index]
                                    ? const Color.fromARGB(255, 246, 144, 121)
                                    : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedColorsList[index] =
                                      !selectedColorsList[index];
                                  // Update appState.colorsShoe list based on selectedColors
                                  if (selectedColorsList[index]) {
                                    appState.colorsShoe.add(_colors[index]);
                                  } else {
                                    appState.colorsShoe.remove(_colors[index]);
                                  }
                                });
                              },
                              child: Text(color),
                            ),
                          ),
                        ))
                    .values
                    .toList(),
              ),
              const Text('Type'),
              DropdownButton<String>(
                value: appState.typeShoe,
                onChanged: (String? newValue) {
                  setState(() {
                    appState.changeTypeShoe(newValue!);
                  });
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    appState.photoUrlShoe = await uploadImage();
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      FirebaseFirestore.instance
                          .collection('shoe')
                          .doc(appState.actualShoe)
                          .set({
                        'Waterproof': appState.waterproofShoe,
                        'Type': appState.typeShoe,
                        'PhotoURL': appState.photoUrlShoe,
                        'Name': appState.nameShoe,
                        'Brand': appState.brandShoe,
                        'Seasons': appState.seasonShoe,
                        'Colors': appState.colorsShoe,
                        'IdUser': appState.uid,
                        'DateLastWorn': DateTime.now(),
                      }).then((value) {
                        appState.changeIndexMyHomePage(1);
                        appState.changeChange(false);
                        print('Document modifié avec succès');
                      }).catchError((error) {
                        print('Erreur lors de l\'ajout du document: $error');
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
