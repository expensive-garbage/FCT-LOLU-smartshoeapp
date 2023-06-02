import 'package:flutter/material.dart';
import 'package:namer_app/AddShoePage.dart';
import 'package:namer_app/ChangeShoePage.dart';

import 'package:namer_app/ShoeInformation.dart';

import 'package:provider/provider.dart';

import 'MyApp.dart';

import 'HomePage.dart';

import 'ShoePage.dart';

import 'ProfilePage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _children = [
    HomePage(),
    const ShoesInformation(),
    ProfilePage(),
    AddShoePage(),
    ChangeShoePage(),
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var currentIndex = appState.indexMyHomePage;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.grey),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              appState.changeIndexMyHomePage(2);
              appState.changeActualShoe("");
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: appState.actualShoe == ""
          ? _children[currentIndex]
          : appState.change == true
              ? ChangeShoePage()
              : ShoePage(id: appState.actualShoe),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            appState.indexMyHomePage == 3 || appState.indexMyHomePage == 4
                ? 1
                : appState.indexMyHomePage,
        onTap: (int index) {
          // Appeler deux fonctions ici
          appState.changeActualShoe("");
          if (index == 2) {
            appState.changeIndexMyHomePage(2);
            appState.changeChange(false);
            Navigator.pushNamed(context, '/profile');
          } else {
            appState.changeChange(false);
            appState.changeIndexMyHomePage(index);
          }
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
