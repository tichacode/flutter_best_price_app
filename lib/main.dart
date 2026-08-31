import 'screen_main_drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BestPriceApp());
}

class BestPriceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'BEST PRICE';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          // TRY THIS: Change to "Brightness.light"
          //           and see that all colors change
          //           to better contrast a light background.
          brightness: Brightness.light,
          contrastLevel: 0.5
        ),
      ),
      home: MainScreenDrawer()
    );
  }
}