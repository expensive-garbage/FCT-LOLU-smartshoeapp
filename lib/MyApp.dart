import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyHomePage.dart';

class MyApp extends StatelessWidget {
<<<<<<< HEAD

=======
>>>>>>> 43e82c2 (connection to firebase)
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
<<<<<<< HEAD
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 120, 214, 178)),
=======
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 120, 214, 178)),
>>>>>>> 43e82c2 (connection to firebase)
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  //define the data the app needs to function
  var season = 'Spring';
  var nbShoes = 5;
<<<<<<< HEAD
  var photoUrl= 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80';
  var name= 'Classic Sneakers';
  var brand= 'Nike';
  var colors= ['White', 'Black', 'Gray'];
  var waterproof= false;
  var id= '1234';
  var seasonOfShoes = 'Spring';
  var actualShoe = -1;

  //define the functions that change the data
  void changeActualShoe(int index) {
    actualShoe = index;
=======
  var photoUrl =
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80';
  var name = 'Classic Sneakers';
  var brand = 'Nike';
  var colors = ['White', 'Black', 'Gray'];
  var waterproof = false;
  var id = '1234';
  var seasonOfShoes = 'Spring';
  var actualShoe = "";

  //define the functions that change the data
  void changeActualShoe(String id) {
    actualShoe = id;
>>>>>>> 43e82c2 (connection to firebase)
    notifyListeners();
  }

  void changeNbShoes(int index) {
    nbShoes = index;
    notifyListeners();
  }
}
<<<<<<< HEAD

=======
>>>>>>> 43e82c2 (connection to firebase)
