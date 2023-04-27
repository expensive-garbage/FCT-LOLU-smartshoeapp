import 'package:flutter/material.dart';

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