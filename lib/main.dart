import 'package:flutter/material.dart';
import 'package:kineticqr/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code',
     theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue, 
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
     ),
     darkTheme: ThemeData(
       brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          centerTitle: true,
     ),
     buttonTheme:const ButtonThemeData(
          buttonColor: Colors.blueGrey, 
          textTheme: ButtonTextTheme.primary,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey, 
          ),
        ),
     ),
     themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

