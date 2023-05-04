import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'MyApp.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final int id = 0;

  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
                style:TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor:const Color.fromRGBO(25, 131, 123, 1) ,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height,)
        ,
          child: Padding(padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Wearing days of each shoes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
              const SizedBox(height: 16),
              const Text('Humidity Rate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 16),
                ]),
          ),
        ),
        
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          updateState(index, context);
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