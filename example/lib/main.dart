import 'package:flutter/material.dart';
import 'package:lit_starfield/lit_starfield.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            "LitStarfieldDemo",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: LitStarfieldImpl(),
    );
  }
}

class LitStarfieldImpl extends StatelessWidget {
  const LitStarfieldImpl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitStarfieldContainer();
  }
}
