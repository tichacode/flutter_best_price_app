import 'screen_main_drawer.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(BestPriceApp());
}

class BestPriceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'BEST PRICE';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.light,
          contrastLevel: 0.5
        ),
        fontFamily: 'Google Sans'
      ),
      home: MainScreenDrawer()
    );
  }
}