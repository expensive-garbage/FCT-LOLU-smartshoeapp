import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'MyApp.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  final int id = 0;

  void _navigateToStatistics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  void updateState(int index, BuildContext context) {
    if (index != 2) {
      Navigator.pushNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;

    return Scaffold(
      body: Column(
        children: [
          Container(
            //width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height*0.1,
            color: const Color.fromRGBO(25, 131, 123, 1),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      //width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height*0.3,
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(
                          Icons.person_3,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    //const SizedBox(height: 10),
                    const Text('Lucie Boucher',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ]),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'My profile overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Icon(
                Icons.show_chart,
                size: 40,
                color: Color.fromRGBO(25, 131, 123, 1),
              ),
              const SizedBox(width: 20),
              const Text(
                'Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                  onPressed: () => _navigateToStatistics(context),
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor:
                          const Color.fromARGB(255, 219, 129, 129)),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: Color.fromRGBO(202, 171, 236, 0.498),
                  )),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              const Icon(
                Icons.settings,
                size: 40,
                color: Color.fromRGBO(25, 131, 123, 1),
              ),
              const SizedBox(width: 20),
              const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                onPressed: () => _navigateToStatistics(context),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color.fromARGB(255, 219, 129, 129)),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: Color.fromRGBO(202, 171, 236, 0.498),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              const Icon(
                Icons.people,
                size: 40,
                color: Color.fromRGBO(25, 131, 123, 1),
              ),
              const SizedBox(width: 20),
              const Text(
                'Change Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton(
                onPressed: () => _navigateToStatistics(context),
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color.fromARGB(255, 219, 129, 129)),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: Color.fromRGBO(202, 171, 236, 0.498),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          // Appeler deux fonctions ici
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
