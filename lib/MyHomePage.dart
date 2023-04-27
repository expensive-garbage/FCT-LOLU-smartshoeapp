import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:namer_app/ShoeInformation.dart';
>>>>>>> 43e82c2 (connection to firebase)
import 'package:provider/provider.dart';

import 'MyApp.dart';

import 'HomePage.dart';

<<<<<<< HEAD
import 'ShoeRackPage.dart';
import 'ShoePage.dart';

  final shoeRackPageStateeKey = GlobalKey<_ShoeRackPageState>();


class MyHomePage extends StatefulWidget {


=======
import 'ShoePage.dart';

import 'ShoeRackPage.dart';

import 'ProfilePage.dart';

class MyHomePage extends StatefulWidget {
>>>>>>> 43e82c2 (connection to firebase)
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
<<<<<<< HEAD



=======
>>>>>>> 43e82c2 (connection to firebase)
  void updateState(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
<<<<<<< HEAD
  int _currentIndex = 0;

  final List<Widget> _children = [    HomePage(),    ShoeRackPage(key: shoeRackPageStateeKey,),    ShoePage(id:42)];

  @override
  Widget build(BuildContext context) {

    
    var appState = context.watch<MyAppState>();
    
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Colors.grey),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              updateState(2);
              appState.changeActualShoe(-1);
=======

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
>>>>>>> 43e82c2 (connection to firebase)
            },
          ),
        ],
      ),
<<<<<<< HEAD
      body: appState.actualShoe == -1? _children[_currentIndex]: ShoePage(id:appState.actualShoe),
=======
      body: appState.actualShoe == ""
          ? _children[_currentIndex]
          : ShoePage(id: appState.actualShoe),
>>>>>>> 43e82c2 (connection to firebase)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // Appeler deux fonctions ici
          updateState(index);
<<<<<<< HEAD
          appState.changeActualShoe(-1);
        },
        selectedItemColor: Color.fromRGBO(25, 131, 123, 1),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: [
=======
          appState.changeActualShoe("");
        },
        selectedItemColor: const Color.fromRGBO(25, 131, 123, 1),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: const [
>>>>>>> 43e82c2 (connection to firebase)
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
<<<<<<< HEAD
            label : 'Shoe Rack',
=======
            label: 'Shoe Rack',
>>>>>>> 43e82c2 (connection to firebase)
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
<<<<<<< HEAD


class ShoeRackPage extends StatefulWidget {

  ShoeRackPage({Key? key}) : super(key: key);

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
          for(var i = 0; i <= nbShoes; i++)
            ElevatedButton(
              onPressed: (){
                //go to shoe page by changing the index of the children of the scaffold
                print('button pressed!');
                appState.changeActualShoe(i);
              },
              child: Text('Shoe $i')
            ),

          ElevatedButton(
            onPressed: (){
              print('button pressed!');
              appState.changeNbShoes(appState.nbShoes + 1);
            },
            child: Text('Add a shoe')
          )

        ],
      ),
    );
  }
}
=======
>>>>>>> 43e82c2 (connection to firebase)
