import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

import 'HomePage.dart';

import 'ShoeRackPage.dart';
import 'ShoePage.dart';

  final shoeRackPageStateeKey = GlobalKey<_ShoeRackPageState>();


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
            },
          ),
        ],
      ),
      body: appState.actualShoe == -1? _children[_currentIndex]: ShoePage(id:appState.actualShoe),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // Appeler deux fonctions ici
          updateState(index);
          appState.changeActualShoe(-1);
        },
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