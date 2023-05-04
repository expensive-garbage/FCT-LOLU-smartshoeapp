import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyApp.dart';

class ShoePage extends StatelessWidget {
  String? id;

  ShoePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var photoUrl = appState.photoUrlShoe;
    var name = appState.nameShoe;
    var brand = appState.brandShoe;
    var colors = appState.colorsShoe;
    var waterproof = appState.waterproofShoe;
    var seasonOfShoes = appState.seasonShoe;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(photoUrl),
            const SizedBox(height: 8.0),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              brand,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Colors: ${colors.join(", ")}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Season: $seasonOfShoes',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Waterproof: ${waterproof ? "Yes" : "No"}',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'ID: $id',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
