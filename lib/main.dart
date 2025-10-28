import 'package:flutter/material.dart';
import 'package:myagemas/Pages/home/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MyAGEMAS',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
