import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyApp.dart';
import 'Season.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var currentOutfitIndex = 0;
  @override
  FutureBuilder<QuerySnapshot<Object?>> build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var season = appState.season;
    String uid = appState.uid;
    Size screenSize = MediaQuery.of(context).size;
    final Stream<QuerySnapshot> _shoesStreamNC = FirebaseFirestore.instance
        .collection('shoe')
        .where('IdUser', isEqualTo: uid)
        .where('NeedCleaning', isEqualTo: true)
        .snapshots();
    final Stream<QuerySnapshot> _shoesStreamOutfit = FirebaseFirestore.instance
        .collection('shoe')
        .where('IdUser', isEqualTo: uid)
        .where('Seasons', arrayContains: season)
        .orderBy('DateLastWorn')
        .snapshots();

    return FutureBuilder(
      future: _shoesStreamOutfit.first,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement pendant que les données sont en cours de récupération
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Afficher un message d'erreur s'il y a une erreur lors de la récupération des données
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Les données ont été récupérées avec succès
          var firstDocument = snapshot.data!.docs.first;
          var colorsOfOldestShoe =
              (firstDocument.data() as Map<String, dynamic>)['Colors'];

          final CollectionReference outfitsCollection =
              FirebaseFirestore.instance.collection('outfit');

          Query query = outfitsCollection.where('Colors',
              arrayContainsAny: colorsOfOldestShoe);

          if (season == "Spring") {
            query = query.where('Spring', isEqualTo: true);
          } else if (season == "Summer") {
            query = query.where('Summer', isEqualTo: true);
          } else if (season == "Fall") {
            query = query.where('Fall', isEqualTo: true);
          } else if (season == "Winter") {
            query = query.where('Winter', isEqualTo: true);
          } else {
            query = query.where('Spring', isEqualTo: true);
          }

          final Stream<QuerySnapshot> _outfitStream = query.snapshots();

          // Construire le reste du widget en utilisant les données récupérées
          return SingleChildScrollView(
            child: Center(
                child: Column(children: [
              Season(season: season),
              const Text("Try this pair of shoes with this outfit"),
              Row(children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _shoesStreamOutfit,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return const Text('An error occurred');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Text('No matching shoes');
                    } else {
                      final oldestShoe = snapshot.data!.docs.first;
                      Map<String, dynamic> oldestShoeData =
                          oldestShoe.data() as Map<String, dynamic>;

                      return Expanded(
                        child: SizedBox(
                          width: screenSize.width * 0.7,
                          height: screenSize.height *
                              0.35, // Ajoutez la hauteur souhaitée pour l'image
                          child: ClipRRect(
                            child: oldestShoeData['PhotoURL'] == ""
                                ? const Text("No Image Here")
                                : CachedNetworkImage(
                                    imageUrl: oldestShoeData['PhotoURL'],
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.contain),
                          ),
                        ),
                      );
                    }
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _outfitStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return const Text('An error occurred');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Text('No matching outfits');
                    } else {
                      final outfit = snapshot.data!.docs[
                          currentOutfitIndex % (snapshot.data!.docs.length)];
                      Map<String, dynamic> outfitData =
                          outfit.data() as Map<String, dynamic>;

                      return Expanded(
                        child: SizedBox(
                          width: screenSize.width * 0.2,
                          height: screenSize.height * 0.35,
                          // Ajoutez la hauteur souhaitée pour l'image
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: outfitData['PhotoURL'] == ""
                                ? const Text("No Image Here")
                                : CachedNetworkImage(
                                    imageUrl: outfitData['PhotoURL'],
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.contain),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ]),
              SizedBox(
                height: screenSize.height * 0.03,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Augmenter l'index de 1 pour passer à l'outfit suivant
                    currentOutfitIndex = (currentOutfitIndex + 1);
                  });
                },
                child: const Text('Other Recommendations'),
              ),
              SizedBox(
                height: screenSize.height * 0.03,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _shoesStreamNC,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return Column(
                    children: [
                      const Text('Need Cleaning:'),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2, // Number of columns
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                appState.changeActualShoe(document.id);
                                appState.changePhotoUrlShoe(data['PhotoURL']);
                                appState.changeNameShoe(data['Name']);
                                appState.changeBrandShoe(data['Brand']);
                                appState.changeColorsShoe(data['Colors']);
                                appState
                                    .changeWaterproofShoe(data['Waterproof']);
                                appState.changeSeasonShoe(data['Seasons']);
                                appState.changeTypeShoe(data['Type']);
                                appState.changeNcShoe(data['NeedCleaning']);
                                appState.changeDateShoe(data['DateLastWorn']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 4,
                                    104, 130), // Set the background color
                                foregroundColor:
                                    Colors.grey, // Set the text color
                                //padding: const EdgeInsets.all(1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // Set the border radius
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CachedNetworkImage(
                                      imageUrl: data['PhotoURL'],
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Text(data['Name'],
                                      style: TextStyle(
                                          color: Colors.grey[300]!,
                                          fontSize: 20)),
                                  Text(data['Brand'],
                                      style: TextStyle(
                                          color: Colors.grey[300]!,
                                          fontSize: 20)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            ])),
          );
        } else {
          // Aucune donnée disponible
          return const Text('No data');
        }
      },
    );
  }
}
