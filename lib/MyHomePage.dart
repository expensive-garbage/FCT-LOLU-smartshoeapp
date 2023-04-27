import 'package:flutter/material.dart';
import 'package:namer_app/ShoeInformation.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

import 'HomePage.dart';

import 'ShoePage.dart';

import 'ShoeRackPage.dart';

import 'ProfilePage.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  void updateState(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    ShoesInformation(),
    ProfilePage(),
    ShoeRackPage(
      key: shoeRackPageStateeKey,
    )
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.grey),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              updateState(2);
              appState.changeActualShoe("");
            },
          ),
        ],
      ),
      body: appState.actualShoe == ""
          ? _children[_currentIndex]
          : ShoePage(id: appState.actualShoe),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // Appeler deux fonctions ici
          updateState(index);
          appState.changeActualShoe("");
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
