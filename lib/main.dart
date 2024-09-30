import 'package:flutter/material.dart';
import 'package:flutter_application_2/SearchPage.dart';

void main() {
  runApp(UAVA());
}

class UAVA extends StatelessWidget {
  const UAVA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAVA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
