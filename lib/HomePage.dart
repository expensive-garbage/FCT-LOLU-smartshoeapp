import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyApp.dart';
import 'Season.dart';

class HomePage extends StatelessWidget {
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
        .where('NeedCleaning', isEqualTo: true)
        .snapshots();
    var appState = context.watch<MyAppState>();
    var season = appState.season;
    return StreamBuilder<QuerySnapshot>(
      stream: _shoesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Center(
          child: Column(
            children: [
              Season(season: season),
              Text("Try this pair of shoes with this outfit"),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Shoe'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Outfit'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Other Recommendations'),
              ),
              Text('Need Cleaning'),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2, // Number of columns
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
                        appState.changeWaterproofShoe(data['Waterproof']);
                        appState.changeSeasonShoe(data['Seasons']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(
                            25, 131, 123, 1), // Set the background color
                        foregroundColor: Colors.grey, // Set the text color
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
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20)),
                          Text(data['Brand'],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
