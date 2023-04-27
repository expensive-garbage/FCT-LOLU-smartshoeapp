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
                  return ElevatedButton(
                    onPressed: () {
                      appState.changeActualShoe(document.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                          25, 131, 123, 1), // Set the background color
                      foregroundColor: Colors.grey, // Set the text color
                      padding: EdgeInsets.all(16), // Set the padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Set the border radius
                      ),
                    ),
                    child: ListTile(
                      title: Text(data['Name']),
                      subtitle: Text(data['Brand']),
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
