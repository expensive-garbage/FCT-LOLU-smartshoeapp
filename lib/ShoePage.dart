import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

class ShoePage extends StatelessWidget {
  String? id;
  ShoePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var photoUrl = appState.photoUrlShoe;
    var name = appState.nameShoe;
    var brand = appState.brandShoe;
    var colorsString = appState.colorsShoe;
    List<Color> colors = colorsString.map((colorString) {
      switch (colorString.toLowerCase()) {
        case 'grey':
          return Colors.grey;
        case 'blue':
          return Colors.blue;
        case 'red':
          return Colors.red;
        case 'green':
          return Colors.green;
        case 'yellow':
          return Colors.yellow;
        case 'orange':
          return Colors.orange;
        case 'white':
          return Colors.white;
        case 'pink':
          return Colors.pink;
        case 'black':
          return Colors.black;
        default:
          return Colors.purple;
      }
    }).toList();

    var waterproof = appState.waterproofShoe;
    var seasonOfShoes = appState.seasonShoe;
    String seasons = seasonOfShoes.length == 1
        ? seasonOfShoes[0]
        : seasonOfShoes.sublist(0, seasonOfShoes.length - 1).join(', ') +
            ' and ' +
            seasonOfShoes.last;

    void deleteShoe() async {
      try {
        appState.changeIndexMyHomePage(1);
        appState.changeActualShoe("");
        await FirebaseFirestore.instance.collection('shoe').doc(id).delete();
        print('La chaussure a été supprimée avec succès.');
      } catch (e) {
        print('Erreur lors de la suppression de la chaussure : $e');
      }
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                  child: photoUrl == ""
                      ? const Text("Any Photo Here")
                      : Image.network(photoUrl, height: 200)),
              const SizedBox(height: 8.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Brand: $brand",
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 18.0),
                    Row(
                      children: [
                        const Text(
                          'Waterproof:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          waterproof ? Icons.check : Icons.close,
                          color: waterproof ? Colors.green : Colors.red,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              const Center(
                child: Text(
                  "Colors:",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: SizedBox(
                  height:
                      60, // Spécifiez la hauteur souhaitée pour le Container
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      child: GridView.builder(
                        itemCount: colors.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              10, // Nombre de colonnes dans la grille
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: colors[index] == Colors.purple
                                      ? const LinearGradient(colors: [
                                          Colors.blue,
                                          Colors.yellow,
                                          Colors.red
                                        ])
                                      : LinearGradient(colors: [
                                          colors[index],
                                          colors[index]
                                        ]),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Seasons:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  seasons,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'ID: $id',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                height: 60.0,
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            appState.changeChange();
                            appState.changeIndexMyHomePage(4);
                          },
                          child: const Text("Change Shoe")),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                          onPressed: () {
                            deleteShoe();
                          },
                          child: const Text("Delete Shoe"))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
