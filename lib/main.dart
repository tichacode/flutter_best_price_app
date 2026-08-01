import 'screen_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(BestPriceApp());
}

class BestPriceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'Find Best Price!';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body:             
            MainScreen()
      ),
    );
  }
}
