import 'screen_result.dart';
import 'screen_input.dart';
import 'database_helper.dart';
import 'extention.dart';
import 'items_format.dart';
import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  static final dbHelper = DatabaseHelper();
  List<ProductPrice> items = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final data = await dbHelper.fetchPrice();
    setState(() {
      items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pinHeaderList = [];

    // Add and clear all button
    pinHeaderList.add(
      Row(
        spacing: 40,
        children: <Widget>[
          // Add button
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => InputPrice(0, 0, 1, 1, "", _fetchItems),
                  ),
                );
              },
            ),
          ),

          // Clear all button
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear all'),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete'),
                  content: const Text('Clear all data'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await MainScreenState.dbHelper.deleteAllPrice();
                        _fetchItems();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              ),
            )
          ),
        ]
      )
    );

    // header
    pinHeaderList.add(DataHeader(0, 28, 28, 28, 0, 16));

    // divider
    pinHeaderList.add(
      const DashedDivider(
        color: Colors.grey,
        thickness: 0.5,
        dashLength: 7,
        dashSpace: 4,
        height: 10,
      ),
    );


    return Scaffold(
      appBar: AppBar(title: Text('Find Best Price!')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: CustomScrollView(
          slivers: 
          // elementList,
          [
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
            
            items.isEmpty
            ? const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No data found', style: TextStyle(color: Colors.grey)),
                  ),
                ),
              )

            // The scrollable body content
            : SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, i) => _ItemList(items[i].id, items[i].price, items[i].piece, items[i].quantity, items[i].note, _fetchItems),
                  childCount: items.length,
              ),
            ),
          ],
        )
      ),

      // Calculate button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (items.isEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Warning!'),
                content: const Text('No data for calculate, please fill data.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  )
                ],
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => ResultScreen(),
              ),
            );
          }
        },
        label: const Text('Calculate!')
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  final int id;
  final double price;
  final double piece;
  final double quantity;
  final String note;
  final Future<void> Function() _fetchItems;

  const _ItemList(this.id, this.price, this.piece, this.quantity, this.note, this._fetchItems);

  @override
  Widget build(BuildContext context) {
    List<Widget> dataRowList = [];

    dataRowList.add(SizedBox(height: 10),);

    dataRowList.add(
      Row(
        children: <Widget>[
          // Expanded(
          //   child: Text(id.toString(), textAlign: TextAlign.center),
          // ),
          Expanded(
            flex: 28,
            child: Text(price.toString(), textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 28,
            child: Text(piece.toString(), textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 28,
            child: Text(quantity.toString(), textAlign: TextAlign.center),
          ),

          Expanded(
            flex: 8,
            child:
              // Edit button
              IconButton (
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => InputPrice(id, price, piece, quantity, note, _fetchItems),
                    ),
                  );
                },
              ),
          ),

          Expanded(
            flex: 8,
            child: 
              // Delete button
              IconButton (
                icon: const Icon(Icons.delete),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete'),
                    content: const Text('Delete this row'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await MainScreenState.dbHelper.deletePrice(id);
                          _fetchItems();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                ),
              ),
          )
        ]
      )
    );

    dataRowList.add(
      Row(
        children: <Widget>[
          Expanded(
            // flex: 3,
            child: Text('Note: $note', textAlign: TextAlign.left),
          )
        ]
      )
    );

    dataRowList.add(
      // Row(
        const Divider(
          thickness: 0.5,
          color: Colors.grey,
        )
      // )
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