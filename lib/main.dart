import 'package:enoxamed_game/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions firebaseOptions = const FirebaseOptions(
    appId: '1:150759456710:android:e7a6ad8e14fdcf7c6bbcc7',
    apiKey: 'AIzaSyC6rZWJzgRs_7WJEZBwN4xvj8o6rbUrsEY',
    projectId: 'enoxamed',
    messagingSenderId: '150759456710',
    storageBucket: 'enoxamed.appspot.com',
  );

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Enoxamed',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

