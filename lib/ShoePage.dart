import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyApp.dart';

<<<<<<< HEAD

class ShoePage extends StatelessWidget {
  final int id;

  const ShoePage({required this.id});

=======
class ShoePage extends StatelessWidget {
  final String id;

  const ShoePage({super.key, required this.id});
>>>>>>> 43e82c2 (connection to firebase)

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var photoUrl = appState.photoUrl;
    var name = appState.name;
    var brand = appState.brand;
    var colors = appState.colors;
    var waterproof = appState.waterproof;
    var seasonOfShoes = appState.seasonOfShoes;

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
<<<<<<< HEAD
              style: TextStyle(
=======
              style: const TextStyle(
>>>>>>> 43e82c2 (connection to firebase)
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
<<<<<<< HEAD
}
=======
}
>>>>>>> 43e82c2 (connection to firebase)
