import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
import 'firebase_options.dart';
import 'MyApp.dart';

void main() {
  runApp(MyApp());
}
=======

import 'MyApp.dart';
import 'firebase_options.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

>>>>>>> 43e82c2 (connection to firebase)
