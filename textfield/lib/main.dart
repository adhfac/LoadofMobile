import 'package:flutter/material.dart';
import 'package:textfield/home_screen.dart';
import 'package:textfield/profile_screen.dart';
import 'package:textfield/text_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings){
        switch (settings.name){
          case '/':
7[]          return MaterialPageRoute(builder: (_)=> HomeScreen());  
          case '/form':
          return MaterialPageRoute(builder: (_)=> const TextScreen());
          case '/profile':
          return MaterialPageRoute(builder: (_)=> ProfileScreen());
          default :
          return MaterialPageRoute(builder: (_)=> HomeScreen());
        }
      },
    );
  }
}
