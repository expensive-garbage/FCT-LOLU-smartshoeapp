import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/FirstPage.dart';
import 'package:namer_app/ProfilePage.dart';
import 'package:provider/provider.dart';

import 'MyHomePage.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Smart Shoe Rack',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 4, 104, 130)),
        ),
        //home: MyHomePage(),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          "/home": (context) => MyHomePage(),
          '/': (context) => context.watch<MyAppState>().uid != ''
              ? MyHomePage()
              : FirstPage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  //define the data the app needs to function
  var season = "Spring";

  var photoUrlShoe = "";
  var nameShoe = "";
  var brandShoe = "";
  var colorsShoe = [];
  var waterproofShoe = false;
  var seasonShoe = [];
  var actualShoe = "";
  var typeShoe = "";
  var dateShoe = Timestamp.now();
  var ncShoe = false;

  void changeDateShoe(Timestamp newDate) {
    dateShoe = newDate;
    notifyListeners();
  }

  void changeNcShoe(bool newValue) {
    ncShoe = newValue;
    notifyListeners();
  }

  void changeTypeShoe(String newType) {
    typeShoe = newType;
    notifyListeners();
  }

  var indexMyHomePage = 0;
  var indexProfilePage = 0;
  var indexFirstPage = 0;

  var auth = FirebaseAuth.instance;
  var uid = '';

  var change = false;

  checkiflogged() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        uid = user.uid;
      } else {
        uid = '';
      }
    });
    notifyListeners();
  }

  //define the functions that change the data
  void changeIndexMyHomePage(int index) {
    indexMyHomePage = index;
    notifyListeners();
  }

  void changeIndexProfilePage(int index) {
    indexProfilePage = index;
    notifyListeners();
  }

  void changeIndexFirstPage(int index) {
    indexFirstPage = index;
    notifyListeners();
  }

  void changeActualShoe(String id) {
    actualShoe = id;
    notifyListeners();
  }

  void changeBrandShoe(String brand) {
    brandShoe = brand;
    notifyListeners();
  }

  void changeWaterproofShoe(bool waterproof) {
    waterproofShoe = waterproof;
    notifyListeners();
  }

  void changeNameShoe(String name) {
    nameShoe = name;
    notifyListeners();
  }

  void changeColorsShoe(List colors) {
    colorsShoe = colors;
    notifyListeners();
  }

  void changeSeasonShoe(List season) {
    seasonShoe = season;
    notifyListeners();
  }

  void changePhotoUrlShoe(String url) {
    photoUrlShoe = url;
    notifyListeners();
  }

  void changeChange(bool newchange) {
    change = newchange;
    notifyListeners();
  }
}
