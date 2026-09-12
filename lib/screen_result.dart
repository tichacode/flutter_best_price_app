import 'database_helper.dart';
import 'extention.dart';
import 'items_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ResultScreen extends StatelessWidget {
  final int pack_id;
  final String pack_name;
  final Future<void> Function() fetchItemsPack;
  final Future<void> Function(String) onPackModifyTapped;
  final Future<void> Function() deletePack;

  const ResultScreen(this.pack_id, this.pack_name, this.fetchItemsPack, this.onPackModifyTapped, this.deletePack);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TITLE_TEXT),
      body: CalculateResultScreen(pack_id, pack_name, fetchItemsPack, onPackModifyTapped, deletePack)
    );
  }
}


class CalculateResultScreen extends StatefulWidget {
  final int pack_id;
  final String pack_name;
  final Future<void> Function() fetchItemsPack;
  final Future<void> Function(String) onPackModifyTapped;
  final Future<void> Function() deletePack;

  const CalculateResultScreen(this.pack_id, this.pack_name, this.fetchItemsPack, this.onPackModifyTapped, this.deletePack);

  @override
  _CalculateResulScreenState createState() => _CalculateResulScreenState();
}

class _CalculateResulScreenState extends State<CalculateResultScreen> {
  static final dbHelper = DatabaseHelper();
  List<ProductCal> items = [];
  List<double> bestVal = [];
  late String packName;

  @override
  void initState() {
    super.initState();
    packName = widget.pack_name;
    _calAndFetchItems();
  }

  Future<void> _calAndFetchItems() async {
    final data = await dbHelper.calculatePrice(widget.pack_id);
    final bestList = await dbHelper.bestPrice(widget.pack_id);
    setState(() {
      items = data;
      bestVal = bestList;
    });
  }

  Future<void> _refreshPack() async {
    await widget.fetchItemsPack();

    final pack = await dbHelper.fetchPackById(widget.pack_id);
    if (pack != null && mounted) {
      setState(() {
        packName = pack.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> elementList = [];
    List<Widget> pinHeaderList = [];

    pinHeaderList.add(
      PackHeader(widget.pack_id, packName, _refreshPack, widget.onPackModifyTapped, widget.deletePack)
    );

    // pinHeaderList.add(
    //   Row(
    //     children: <Widget>[
    //       // Back
    //       Expanded(
    //         child: ElevatedButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           child: const Text('Back'),
    //         ),
    //       ),
    //     ]
    //   )
    // );

    pinHeaderList.add(
      Row(
        children: <Widget>[
          Expanded(
            flex: 100,
            child: Text("Price per unit = Price ÷ ( Piece x Quantity )", style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center,)
          ),
        ]
      )
    );

    pinHeaderList.add(
      Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(height: 5)
          ),
        ]
      )
    );


    // header
    pinHeaderList.add(DataHeader(8, 23, 23, 23, 23, 0));

    // dash divider
    pinHeaderList.add(
      const DashedDivider(
        color: Colors.grey,
        thickness: 0.5,
        dashLength: 7,
        dashSpace: 4,
        height: 10,
      ),
    );

    // items
    for(var i = 0; i < items.length; i++){
      elementList.add(_ItemResultList(bestVal.indexOf(items[i].calculate), items[i].id, items[i].price, items[i].piece, items[i].quantity, items[i].calculate, items[i].note));
    }

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: 
        CustomScrollView(
          slivers: [
            // header locked at the top
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

            // scrollable body content
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
    
    // rank
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
                TextSpan(
                  text: rankStr,
                ),
                WidgetSpan(
                  child: Image.asset("assets/icon_crown.png", color: rankColor,),
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

    // price data
    dataRowList.add(
      Container(
      margin: const EdgeInsets.only(top:10.0, bottom: 15.0),
      child: 
        Row(
          children: dataRowRank + <Widget>[
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

    // note
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

    // divider
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
          children: dataRowList
        )
      );
  }
}