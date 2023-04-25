import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyApp.dart';
import 'Season.dart';
import 'MyHomePage.dart';


class HomePage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
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
