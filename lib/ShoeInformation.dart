import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyApp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoesInformation extends StatefulWidget {
  const ShoesInformation({Key? key}) : super(key: key);

  @override
  _ShoesInformationState createState() => _ShoesInformationState();
}

class _ShoesInformationState extends State<ShoesInformation> {
  final Stream<QuerySnapshot> _shoesStream =
      FirebaseFirestore.instance.collection('shoe').snapshots();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return StreamBuilder<QuerySnapshot>(
      stream: _shoesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return SingleChildScrollView(
          child: Column(
            children: [
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
                        appState.changeSeasonShoe(data['Season']);
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
              ElevatedButton(
                onPressed: () {
                  appState.changeNbShoes(appState.nbShoes + 1);
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
