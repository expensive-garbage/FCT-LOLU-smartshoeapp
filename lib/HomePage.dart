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

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    String uid = '';
    if (user != null) {
      uid = user.uid;
      print('L\'UID de l\'utilisateur est: $uid');
    } else {
      print('Aucun utilisateur n\'est actuellement authentifié.');
    }
    final Stream<QuerySnapshot> _shoesStream = FirebaseFirestore.instance
        .collection('shoe')
        .where('IdUser', isEqualTo: uid)
        .snapshots();
    var appState = context.watch<MyAppState>();
    var season = appState.season;
    return Center(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _shoesStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  final shoesList = snapshot.data!.docs
                      .where((DocumentSnapshot document) =>
                          (document.data()
                              as Map<String, dynamic>)['NeedCleaning'] ==
                          true)
                      .toList();
                  final shoesList2 =
                      snapshot.data!.docs.where((DocumentSnapshot document) {
                    final data = document.data()! as Map<String, dynamic>;
                    final seasons = data['Seasons'] as List<dynamic>;
                    return seasons.contains(season);
                  }).toList();

                  String oldestShoeName = '';
                  String oldestShoeBrand = '';
                  String oldestShoePhotoUrl = '';
                  if (shoesList2.isNotEmpty) {
                    shoesList2.sort((a, b) {
                      final dateA = (a.data()!
                          as Map<String, dynamic>)['DateLastWorn'] as Timestamp;
                      final dateB = (b.data()!
                          as Map<String, dynamic>)['DateLastWorn'] as Timestamp;
                      return dateA.compareTo(dateB);
                    });

                    oldestShoeName = (shoesList2.first.data()!
                        as Map<String, dynamic>)['Name'];
                    oldestShoeBrand = (shoesList2.first.data()!
                        as Map<String, dynamic>)['Brand'];
                    oldestShoePhotoUrl = (shoesList2.first.data()!
                        as Map<String, dynamic>)['PhotoURL'];
                  }
                  print('photoURL: $oldestShoePhotoUrl');
                  if (shoesList.isNotEmpty) {
                    return Column(
                      children: [
                        Season(season: season),
                        const Text("Try this pair of shoes with this outfit"),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {},
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
                                    Text(oldestShoeName,
                                        style: TextStyle(
                                            color: Colors.grey[300]!,
                                            fontSize: 20)),
                                    Text(oldestShoeBrand,
                                        style: TextStyle(
                                            color: Colors.grey[300]!,
                                            fontSize: 20)),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Outfit'),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Other Recommendations'),
                        ),
                        Text('Need Cleaning'),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: shoesList.map((DocumentSnapshot document) {
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
                                      child: Image.network(
                                        data['PhotoURL'],
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
                  } else {
                    return Text('No matching shoes');
                  }
                } else {
                  return Text('No shoes available');
                }
              } else if (snapshot.hasError) {
                return Text('An error occurred');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
