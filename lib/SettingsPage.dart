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
  String currentName = '';
  String currentAdress = '';
  String currentPassword = '';
  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/home');
    }
  }

  Future<void> fetchValuesFromDatabase() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseFirestore.instance;
    final documentSnapshot =
        await databaseReference.collection('user').doc(firebaseUser!.uid).get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      setState(() {
        currentName = data!['Name'] ?? '';
        currentHumidityRate = data['Humidity Rate Threshold'] ?? 20.0;
        currentTemperature = data['Temperature Threshold'] ?? 60.0;
        currentAdress = data['email'] ?? '';
        currentPassword = data['password'] ?? '';
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
                    final collectionReference = databaseReference.collection(
                        'user'); // Remplacez 'your_collection' par le nom de votre collection dans la base de données

                    await collectionReference.doc(firebaseUser!.uid).update({
                      'Humidity Rate Threshold': currentHumidityRate,
                      'Temperature Threshold': currentTemperature,
                    });

                    print('Database updated successfully!');
                  },
                  child: const Text("Validation")),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.mail,
                    size: 40,
                    color: Color.fromRGBO(25, 131, 123, 1),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Modify your mail address',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Modify your mail address'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'New mail address',
                                          hintText: currentAdress,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          icon: Icon(Icons.mail_lock),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 129, 129)),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromRGBO(202, 171, 236, 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.password,
                    size: 40,
                    color: Color.fromRGBO(25, 131, 123, 1),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Modify your password',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Modify your password'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'New Password',
                                          hintText: currentPassword,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          icon: Icon(Icons.password),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 129, 129)),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromRGBO(202, 171, 236, 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.image_search,
                    size: 40,
                    color: Color.fromRGBO(25, 131, 123, 1),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Modify your profile picture',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Modify your profile picture'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'New Profile picture',
                                          icon: Icon(Icons.image_search),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 129, 129)),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromRGBO(202, 171, 236, 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.text_fields,
                    size: 40,
                    color: Color.fromRGBO(25, 131, 123, 1),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Modify your name',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const Expanded(child: SizedBox()),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Modify your name'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'New name',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          hintText: currentName,
                                          icon: Icon(Icons.people),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 129, 129)),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromRGBO(202, 171, 236, 0.8),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
