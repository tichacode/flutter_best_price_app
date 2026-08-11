import 'screen_main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BestPriceApp());
}

class BestPriceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const title = 'Find Best Price!';

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
      home: MainScreen()
    );
  }
}


class TestScreen extends StatefulWidget {
  @override
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
  slivers: [
    // This header stays locked at the top
    PinnedHeaderSliver(
      child: Container(
        height: 80,
        color: Colors.amber,
        alignment: Alignment.center,
        child: Column(spacing:20, children: <Widget>[Text('Pinned Header'), Text('Test')]), //const Text('Pinned Header', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    ),
    // The scrollable body content
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Column(spacing:20, children: <Widget>[Text('List Item #$index'), Text('Test')]),//ListTile(title: Text('List Item #$index')),
        childCount: 40,
      ),
    ),
  ],
);
  }
  }