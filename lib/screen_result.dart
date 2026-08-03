import 'database_helper.dart';
import 'extention.dart';
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
    // Add and clear all button
    // elementList.add(const SizedBox(height: 20), );

    elementList.add(
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
    elementList.add(
      Row(

        children: <Widget>[
          // rank
          Expanded(
            flex: 8,
            child: 
              SizedBox(height: 10,),
          ),

          // header: price
          Expanded(
            flex: 23,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Price",
                  ),
                  WidgetSpan(
                    child: Icon(Icons.monetization_on_rounded, size: 14),
                  ),
                ],
              ),
            )
          ),

          // header: piece
          Expanded(
            flex: 23,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Piece",
                  ),
                  WidgetSpan(
                    child: Icon(Icons.question_mark, size: 14),
                  ),
                ],
              ),
            )
          ),

          // header: quantity
          Expanded(
            flex: 23,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Quantity",
                  ),
                  WidgetSpan(
                    child: Icon(Icons.water_drop_rounded, size: 14),
                  ),
                ],
              ),
            )
          ),


          // header: price per quantity
          Expanded(
            flex: 23,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Price per unit",
                  ),
                  // WidgetSpan(
                  //   child: Icon(Icons.water_drop_rounded, size: 14),
                  // ),
                ],
              ),
            )
          ),

        ]
      )
    );

    elementList.add(
      // const Divider(
      //   thickness: 0.5,
      //   color: Colors.grey,
      // )
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
      child: SizedBox(
          width: double.maxFinite,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20.0,
            children: elementList
            )
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
    String rankStr = "";
    if (rank != -1) {
      rankStr = (rank + 1).toString();
    }

    dataRowList.add(
      Container(
      // padding: const EdgeInsets.symmetric(vertical: 26.0),
      margin: const EdgeInsets.only(top:10, bottom: 15),
      child: 
        Row(
          children: <Widget>[
            // Expanded(
            //   child: Text(id.toString(), textAlign: TextAlign.center),
            // ),

            Expanded(
              flex: 8,
              child:
                Text(rankStr, textAlign: TextAlign.center)
            ),

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
            flex: 92,
            child: Text('Note: $note', textAlign: TextAlign.left, style: TextStyle(color: Color.fromARGB(255, 95, 95, 95)),),
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