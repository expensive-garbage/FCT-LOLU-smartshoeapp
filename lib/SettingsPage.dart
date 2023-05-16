import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MyApp.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final int id = 0;
  double currentHumidityRate = 20.0;
  double currentTemperature = 60.0;

  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/home');
    }
  }

   Future<void> fetchValuesFromDatabase() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    final documentSnapshot = await databaseReference
        .collection('user')
        .doc(firebaseUser!.uid)
        .get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      setState(() {
        currentHumidityRate = data!['Humidity Rate Threshold'] ?? 20.0;
        currentTemperature = data['Temperature Threshold'] ?? 60.0;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    fetchValuesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    
    var appState = context.watch<MyAppState>();
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromRGBO(25, 131, 123, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Action souhaitée lors de l'appui sur le bouton flèche
            // Par exemple, pour revenir à l'écran précédent :
            appState.changeIndexProfilePage(0);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              const Text('Choose your humidity rate threshold',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              SizedBox(height: 16),
              Slider(
                value: currentHumidityRate,
                min: 0,
                max: 100,
                divisions: 50,
                label: currentHumidityRate.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    currentHumidityRate = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Selected: $currentHumidityRate'),
              SizedBox(height: 16),
              const Text('Choose your temperature threshold',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              SizedBox(height: 16),
              Slider(
                value: currentTemperature,
                min: 0,
                max: 100,
                divisions: 50,
                label: currentTemperature.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    currentTemperature = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Selected: $currentTemperature'),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final firebaseUser = FirebaseAuth.instance.currentUser;
                  final databaseReference = FirebaseFirestore.instance;
                  final collectionReference = databaseReference.collection('user'); // Remplacez 'your_collection' par le nom de votre collection dans la base de données
                  
                  await collectionReference.doc(firebaseUser!.uid).update({
                    'Humidity Rate Threshold': currentHumidityRate,
                    'Temperature Threshold': currentTemperature,
                  });

                  print('Database updated successfully!');
                },
                child: const Text("Validation"))
            ]),
          ),
        ),
      ),
    );
  }
}
