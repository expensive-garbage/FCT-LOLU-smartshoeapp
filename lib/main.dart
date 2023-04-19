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
  var photoUrl= 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80';
  var name= 'Classic Sneakers';
  var brand= 'Nike';
  var colors= ['White', 'Black', 'Gray'];
  var waterproof= false;
  var id= '1234';
  var seasonOfShoes = 'Spring';

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
              onTabTapped(2);
            },
          ),
        ],
      ),
      body:_children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
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
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
    return Text('It is $season', 
      style: TextStyle(
        color: Color.fromRGBO(25, 131, 123, 1),
        fontWeight: FontWeight.bold,
        fontSize: 18.0,),);
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    var season = appState.season;


    return Center(
      child: Column(
        children: [
          Season(season: season),
          Text ("Try this pair of shoes with this outfit"),
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
          ElevatedButton(
              onPressed: () {},
              child: Text('Other Recommendations'),
              ),
          Text('Need Cleaning'),
          Row(children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Shoe'),
            ),
          ],
          ),
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

class ShoePage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var photoUrl = appState.photoUrl;
    var name = appState.name;
    var brand = appState.brand;
    var colors = appState.colors;
    var waterproof = appState.waterproof;
    var seasonOfShoes = appState.seasonOfShoes;
    var id = appState.id;

    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(photoUrl),
            SizedBox(height: 16.0),
            Text(
              name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              brand,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Colors: ${colors.join(", ")}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Season: $seasonOfShoes',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Waterproof: ${waterproof ? "Yes" : "No"}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'ID: $id',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
