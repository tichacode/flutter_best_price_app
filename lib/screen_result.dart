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
    // Add and clear all button
    // elementList.add(const SizedBox(height: 20), );

    pinHeaderList.add(
      PackHeader(widget.pack_id, packName, _refreshPack, widget.onPackModifyTapped, widget.deletePack)
    );

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
                TextSpan(
                  text: rankStr,
                ),
                WidgetSpan(
                  child: Image.asset("icon_crown.png", color: rankColor,),
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