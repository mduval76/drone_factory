import 'package:drone_factory/views/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.amber,
            fontSize: 30,
            fontFamily: 'CocomatLight',
            fontWeight: FontWeight.bold
          ),
        )
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DRONE FACTORY'),
        ),
        body: const HomeScreen(),
      ),
    );
  }
}
