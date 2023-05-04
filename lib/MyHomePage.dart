import 'package:flutter/material.dart';
import 'package:namer_app/AddShoePage.dart';

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
  void updateState(int index) {
    setState(() {
      if (index == 2) {
        Navigator.pushNamed(context, '/profile');
      }
    });
  }

  final List<Widget> _children = [
    HomePage(),
    const ShoesInformation(),
    ProfilePage(),
    AddShoePage(),
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
              updateState(2);
              appState.changeActualShoe("");
            },
          ),
        ],
      ),
      body: appState.actualShoe == ""
          ? _children[currentIndex]
          : ShoePage(id: appState.actualShoe),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            appState.indexMyHomePage == 3 ? 1 : appState.indexMyHomePage,
        onTap: (int index) {
          // Appeler deux fonctions ici
          if (index == 2) {
            appState.indexMyHomePage = index;
            updateState(index);
          } else {
            appState.changeIndexMyHomePage(index);
          }
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

class ShoeRackPage extends StatefulWidget {
  const ShoeRackPage({Key? key}) : super(key: key);

  @override
  State<ShoeRackPage> createState() => _ShoeRackPageState();
}

class _ShoeRackPageState extends State<ShoeRackPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var nbShoes = appState.nbShoes;

    return Center(
      child: Column(
        children: [
          //Shoe display
          //here generate nbShoes buttons in a grille
          for (var i = 0; i <= nbShoes; i++)
            ElevatedButton(
                onPressed: () {
                  //go to shoe page by changing the index of the children of the scaffold
                  appState.changeActualShoe("lol");
                },
                child: Text('Shoe $i')),

          ElevatedButton(
              onPressed: () {
                appState.changeNbShoes(appState.nbShoes + 1);
              },
              child: const Text('Add a shoe'))
        ],
      ),
    );
  }
}
