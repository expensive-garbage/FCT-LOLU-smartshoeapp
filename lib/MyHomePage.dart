import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

import 'HomePage.dart';
import 'ShoeRackPage.dart';
import 'ShoePage.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {


  void updateState(int index) {
  // Modifiez l'état de votre widget ici
  setState(() {
    _currentIndex = index;
  });
  }

  int _currentIndex = 0;

  final List<Widget> _children = [    HomePage(),    ShoeRackPage(),    ShoePage()];


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
            },
          ),
        ],
      ),
      body:_children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: updateState,
        selectedItemColor: Color.fromRGBO(25, 131, 123, 1),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label : 'Shoe Rack',
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