import 'package:flutter/material.dart';
import 'package:food_app/src/screens/main_screen.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Food Delivert App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
        ),
        home: MainScreen(),
      );
  }
}
