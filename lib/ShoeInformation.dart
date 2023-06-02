import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShoesInformation extends StatefulWidget {
  const ShoesInformation({Key? key}) : super(key: key);

  @override
  _ShoesInformationState createState() => _ShoesInformationState();
}

class _ShoesInformationState extends State<ShoesInformation> {
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
    return StreamBuilder<QuerySnapshot>(
      stream: _shoesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
                        appState.changeTypeShoe(data['Type']);
                        appState.changeNcShoe(data['NeedCleaning']);
                        appState.changeDateShoe(data['DateLastWorn']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 4, 104, 130), // Set the background color
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
                            child: data['PhotoURL'] == ""
                                ? const Text("Any Photo Here")
                                : CachedNetworkImage(
                                    imageUrl: data['PhotoURL'],
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                          ),
                          Text(data['Name'],
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 219, 219, 219),
                                  fontSize: 15)),
                          Text(data['Brand'],
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 219, 219, 219),
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  appState.changeActualShoe("");
                  appState.changeIndexMyHomePage(3);
                },
                child: const Text('Add a shoe'),
              ),
            ],
          ),
        );
      },
    );
  }
}
