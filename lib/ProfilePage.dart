import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  final int id = 0;

  @override
  Widget build(BuildContext context) {
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
                  children : [
                  const SizedBox(height: 10),
                  Container(
                  //width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height*0.3,
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
                ),
              
              //const SizedBox(height: 10),
              const Text(
                'Lucie Boucher',
                style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold)),
          ]
          ),
              ),
             ),
          const SizedBox(height: 16),
          const Text(
            'My profile overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ) ,
          ),

          ],
        )
      );
  }
}
