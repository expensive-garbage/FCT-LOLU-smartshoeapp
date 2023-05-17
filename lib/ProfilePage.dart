import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyApp.dart';
import 'StatisticsPage.dart';
import 'SettingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int id = 0;

  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/home');
    }
  }

  final List<Widget> _children = [
    ProfileInformationPage(),
    const StatisticsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var currentIndex = appState.indexProfilePage;
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            appState.indexMyHomePage == 3 ? 1 : appState.indexMyHomePage,
        onTap: (int index) {
          // Appeler deux fonctions ici
          appState.changeIndexProfilePage(0);
          appState.indexMyHomePage = index;
          updateState(index, context);
        },
        selectedItemColor: const Color.fromARGB(255, 4, 104, 130),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Shoe Rack',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}

class ProfileInformationPage extends StatefulWidget {
  const ProfileInformationPage({super.key});

  @override
  State<ProfileInformationPage> createState() => _ProfileInformationPageState();
}

class _ProfileInformationPageState extends State<ProfileInformationPage> {
  Future<void> getName(String uid) async {}

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = '';
    if (user != null) {
      uid = user.uid;
      print('L\'UID de l\'utilisateur est: $uid');
    } else {
      print('Aucun utilisateur n\'est actuellement authentifié.');
    }

    final Stream<DocumentSnapshot> _userStream =
        FirebaseFirestore.instance.collection('user').doc(uid).snapshots();

    var appState = context.watch<MyAppState>();

    return StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          Map<String, dynamic> data =
              snapshot.data!.data()! as Map<String, dynamic>;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 4, 104, 130),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          SizedBox(
                              width: 150,
                              height: 150,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(data['PhotoURL']),
                              )),
                          const SizedBox(height: 10),
                          Text(data['Name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                        ]),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'My profile overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Icon(
                      Icons.show_chart,
                      size: 40,
                      color: Color.fromARGB(255, 4, 104, 130),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Statistics',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                        onPressed: () => appState.changeIndexProfilePage(1),
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor:
                                const Color.fromARGB(255, 219, 129, 129)),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: Color.fromRGBO(202, 171, 236, 0.498),
                        )),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      size: 40,
                      color: Color.fromARGB(255, 4, 104, 130),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () => appState.changeIndexProfilePage(2),
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor:
                              const Color.fromARGB(255, 219, 129, 129)),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: Color.fromRGBO(202, 171, 236, 0.498),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 40,
                      color: Color.fromARGB(255, 4, 104, 130),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Deconnexion',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        appState.changeIndexMyHomePage(0);
                        Navigator.pushNamed(context, '/');
                        appState.changeIndexProfilePage(0);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor:
                              const Color.fromARGB(255, 219, 129, 129)),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                        color: Color.fromRGBO(202, 171, 236, 0.498),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
