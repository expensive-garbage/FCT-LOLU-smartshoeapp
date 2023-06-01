import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                appState.nameShoe = value!;
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
                appState.brandShoe = value!;
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    FirebaseFirestore.instance
                        .collection('shoe')
                        .doc(appState.actualShoe)
                        .set({
                      'Waterproof': appState.waterproofShoe,
                      'Type': 'sneacker',
                      'PhotoURL': appState.photoUrlShoe,
                      'Name': appState.nameShoe,
                      'Brand': appState.brandShoe,
                      'Seasons': appState.seasonShoe,
                      'Colors': appState.colorsShoe,
                      'IdUser': appState.uid,
                      'DateLastWorn': DateTime.now(),
                    }).then((value) {
                      appState.changeIndexMyHomePage(1);
                      appState.changeChange();
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
    );
  }
}
