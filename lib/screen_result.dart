import 'database_helper.dart';
import 'extention.dart';
import 'items_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ResultScreen extends StatelessWidget {
  const ResultScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Find Best Price!')),
      body: CalculateResultScreen()
    );
  }
}


class CalculateResultScreen extends StatefulWidget {
  @override
  _CalculateResulScreenState createState() => _CalculateResulScreenState();
}


class _CalculateResulScreenState extends State<CalculateResultScreen> {
  static final dbHelper = DatabaseHelper();
  List<ProductCal> items = [];
  List<double> bestVal = [];

  @override
  void initState() {
    super.initState();
    _calAndFetchItems();
  }

  Future<void> _calAndFetchItems() async {
    //test: dbHelper.addPrice(ProductPrice(id: 0, price: 0, piece: 1, quantity: 1, note: "test"));
    final data = await dbHelper.calculatePrice();
    final bestList = await dbHelper.bestPrice();
    setState(() {
      items = data;
      bestVal = bestList;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> elementList = [];
    List<Widget> pinHeaderList = [];
    // Add and clear all button
    // elementList.add(const SizedBox(height: 20), );

    pinHeaderList.add(
      Row(
        // spacing: 20,
        children: <Widget>[
          // Add button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ),
        ]
      )
    );

    // header
    pinHeaderList.add(DataHeader(8, 23, 23, 23, 23, 0));

    pinHeaderList.add(
      const DashedDivider(
        color: Colors.grey,
        thickness: 0.5,
        dashLength: 7,
        dashSpace: 4,
        height: 10,
      ),
    );

    for(var i = 0; i < items.length; i++){
      elementList.add(_ItemResultList(bestVal.indexOf(items[i].calculate), items[i].id, items[i].price, items[i].piece, items[i].quantity, items[i].calculate, items[i].note));
    }

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: 
        CustomScrollView(
          slivers: [
            // This header stays locked at the top
            PinnedHeaderSliver(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                alignment: Alignment.center,
                child: Column(
                  spacing: 20.0,
                  children: pinHeaderList
                  )
              ),
            ),

            // The scrollable body content
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ItemResultList(bestVal.indexOf(items[i].calculate), items[i].id, items[i].price, items[i].piece, items[i].quantity, items[i].calculate, items[i].note),
                childCount: items.length,
              ),
            ),
          ],
        )
    );
  }
}

class _ItemResultList extends StatelessWidget {
  final int rank;
  final int id;
  final double price;
  final double piece;
  final double quantity;
  final double calculateVal;
  final String note;

  const _ItemResultList(this.rank, this.id, this.price, this.piece, this.quantity, this.calculateVal, this.note);

  @override
  Widget build(BuildContext context) {
    List<Widget> dataRowList = [];
    List<Widget> dataRowRank = [];
    String rankStr = "";
    if (rank != -1) {
      rankStr = (rank + 1).toString();
    }

    if (rank != -1 && rank < 3) {
      Color rankColor = Colors.orange;
      if (rank == 1) {
        rankColor = Colors.grey;
      } else if (rank == 2) {
        rankColor = const Color.fromARGB(255, 133, 67, 6);
      }
      dataRowRank.add(
        Expanded(
          flex: 8,
          child:
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(
                fontWeight: FontWeight.normal,
              ),
              children: [
                WidgetSpan(
                  child: Image.asset("icon_crown.png", color: rankColor,),
                ),
                TextSpan(
                  text: rankStr,
                ),
              ],
            ),
          )
        ),
      );
    } else {
      dataRowRank.add(
        Expanded(
          flex: 8,
          child:
            Text(rankStr, textAlign: TextAlign.center)
        ),
      );
    }

    dataRowList.add(
      Container(
      // padding: const EdgeInsets.symmetric(vertical: 26.0),
      margin: const EdgeInsets.only(top:10.0, bottom: 15.0),
      child: 
        Row(
          children: dataRowRank + <Widget>[
            // Expanded(
            //   child: Text(id.toString(), textAlign: TextAlign.center),
            // ),

            // Expanded(
            //   flex: 8,
            //   child:
            //     Text(rankStr, textAlign: TextAlign.center)
            // ),

            Expanded(
              flex: 23,
              child: Text(price.toString(), textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 23,
              child: Text(piece.toString(), textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 23,
              child: Text(quantity.toString(), textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 23,
              child: Text(calculateVal.toString(), textAlign: TextAlign.center),
            ),
            
          ]
        )
      )
    );

    dataRowList.add(
      Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: SizedBox(height: 10)
          ),

          Expanded(
            flex: 92,
            child: Text('Note: $note', textAlign: TextAlign.left, style: TextStyle(color: Color.fromARGB(255, 95, 95, 95)),), //Color.fromARGB(255, 95, 95, 95)
          )
        ]
      )
    );

    dataRowList.add(
        const Divider(
          thickness: 0.5,
          color: Colors.grey,
        )
    );

    return 
      SizedBox(
        width: double.maxFinite,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // spacing: 20.0,
          children: dataRowList
        )
      );

    
  }
}