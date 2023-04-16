import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 120, 214, 178)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  //define the data the app needs to function
  var current = WordPair.random();
  var season = 'Spring';
  var nbShoes = 5;

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();


    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = ShoeRackPage();
        break;
      case 2:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              setState(() {
                  selectedIndex = 2;
                });
            },
          ),
        ],
      ),
      body:Row(
          children:[
            Expanded(
            child: Container(
              child: page,
              ),
            ),  
          ],
        ),
      bottomNavigationBar: BottomAppBar(
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          StadiumBorder(),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {setState(() {
                  selectedIndex = 0;
                });},
            ),
            IconButton(
              icon: const Icon(Icons.dashboard_customize_rounded),
              onPressed: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Season extends StatelessWidget {
  const Season({
    super.key,
    required this.season,
  });

  final String season;

  @override
  Widget build(BuildContext context) {
    return Text('It is '+season+'!');
  }
}

class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    var season = appState.season;


    return Center(
      
      child: Column(
        children: [
          Season(season: season),
          Row(children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Shoe'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Outfit'),
              ),
          ],
          ),
          Text('Need Cleaning'),
        ],
      ),
    );
  }
}

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
                print('button pressed!');
                appState.nbShoes--;
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