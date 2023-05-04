import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyHomePage.dart';
import 'MyApp.dart';
import 'StatisticsPage.dart';
import 'SettingsPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int id = 0;

  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/');
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
        currentIndex: appState.indexMyHomePage,
        onTap: (int index) {
          // Appeler deux fonctions ici
          appState.changeIndexProfilePage(0);
          appState.indexMyHomePage = index;
          updateState(index, context);
        },
        selectedItemColor: const Color.fromRGBO(25, 131, 123, 1),
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

class ProfileInformationPage extends StatelessWidget {
  const ProfileInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Column(
      children: [
        Container(
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height*0.1,
          color: const Color.fromRGBO(25, 131, 123, 1),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 10),
              Container(
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height*0.3,
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.person_3,
                    color: Colors.grey,
                  ),
                ),
              ),

              //const SizedBox(height: 10),
              const Text('Lucie Boucher',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              color: Color.fromRGBO(25, 131, 123, 1),
            ),
            const SizedBox(width: 20),
            const Text(
              'Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const Expanded(child: SizedBox()),
            ElevatedButton(
                onPressed: () => appState.changeIndexProfilePage(1),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color.fromARGB(255, 219, 129, 129)),
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
              color: Color.fromRGBO(25, 131, 123, 1),
            ),
            const SizedBox(width: 20),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              onPressed: () => appState.changeIndexProfilePage(2),
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor: const Color.fromARGB(255, 219, 129, 129)),
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
              color: Color.fromRGBO(25, 131, 123, 1),
            ),
            const SizedBox(width: 20),
            const Text(
              'Change Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              onPressed: () => appState.changeIndexProfilePage(1),
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor: const Color.fromARGB(255, 219, 129, 129)),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Color.fromRGBO(202, 171, 236, 0.498),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
