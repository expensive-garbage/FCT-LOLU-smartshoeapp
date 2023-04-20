import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyApp.dart';


class ShoeRackPage extends StatelessWidget {


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
              },
              child: Text('Shoe $i')
            ),

          ElevatedButton(
            onPressed: (){
              print('button pressed!');
              appState.nbShoes++;
            },
            child: Text('Add a shoe')
          )

        ],
      ),
    );
  }
}