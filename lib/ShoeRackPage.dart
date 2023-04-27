import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
import 'MyApp.dart';

=======

import 'MyApp.dart';

final shoeRackPageStateeKey = GlobalKey<_ShoeRackPageState>();

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
          for (var i = 0; i <= nbShoes; i++)
            ElevatedButton(
                onPressed: () {
                  //go to shoe page by changing the index of the children of the scaffold
                  print('button pressed!');
                  appState.changeActualShoe("");
                },
                child: Text('Shoe $i')),

          ElevatedButton(
              onPressed: () {
                print('button pressed!');
                appState.changeNbShoes(appState.nbShoes + 1);
              },
              child: const Text('Add a shoe'))
        ],
      ),
    );
  }
}
>>>>>>> 43e82c2 (connection to firebase)
