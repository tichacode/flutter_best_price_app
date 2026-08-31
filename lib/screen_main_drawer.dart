import 'screen_result.dart';
import 'screen_input.dart';
import 'database_helper.dart';
import 'extention.dart';
import 'items_format.dart';
import 'package:flutter/material.dart';


class MainScreenDrawer extends StatefulWidget {
  const MainScreenDrawer({super.key});

  @override
  State<MainScreenDrawer> createState() => _MainScreenDrawerState();
}

class _MainScreenDrawerState extends State<MainScreenDrawer> {
  static final dbHelper = DatabaseHelper();
  List<PackPrice> packItems = [];
  List<ProductPrice> priceItems = [];
  int _selectedIndex = -1;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w100,
  );

  @override
  void initState() {
    super.initState();
    // dbHelper.addPack(PackPrice(id:0, name:"note2"));
    _fetchItemsPack();
    _fetchItemsPrice();
  }

  Future<void> _fetchItemsPack() async {
    final data = await dbHelper.fetchPack();
    setState(() {
      packItems = data;
    });
  }

  Future<void> _fetchItemsPrice() async {
    if (_selectedIndex != -1) {
      final data = await dbHelper.fetchPrice(packItems[_selectedIndex].id);
      setState(() {
        priceItems = data;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  Future<void> _onPackModifyTapped(String type) async {
    if (type == "Create") {
      await _fetchItemsPack();
      _onItemTapped(packItems.length - 1);
    } 
    else if (type == "Delete") {
      _onItemTapped(-1);
      await _fetchItemsPack();
    } 
    else if (type == "Update") {
      await _fetchItemsPack();
    }
  }

  Future<void> _deletePack() async {
    MainScreenState.dbHelper.deleteAllPrice(packItems[_selectedIndex].id);
    MainScreenState.dbHelper.deletePack(packItems[_selectedIndex].id);
  }


  Widget _getFloatingActionButton() {
    if (_selectedIndex == -1) {
      return
        Container();
    } else {
      return 
        FloatingActionButton.extended(
        onPressed: () {
          if (priceItems.isEmpty) {
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
                builder: (context) => ResultScreen(packItems[_selectedIndex].id, packItems[_selectedIndex].name, _fetchItemsPack, _onPackModifyTapped, _deletePack),
              ),
            );
          }
        },
        label: const Text('Calculate!')
      );
    }
  }

  Widget _getBody() {
    if (_selectedIndex == -1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 40,
          children: <Widget>[
            Text("Let's find best price!", style: optionStyle),

            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => InputPack(0, "", _onPackModifyTapped, null),
                  ),
                );
              },
            ),
          ]
        )
      );
    } else {
      return MainScreen(priceItems, packItems[_selectedIndex].id, packItems[_selectedIndex].name, _fetchItemsPrice, _fetchItemsPack, _onPackModifyTapped, _deletePack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TITLE_TEXT,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: _getBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, 
      floatingActionButton: _getFloatingActionButton(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.brown),
              child: Center(
                child: Text(
                  "Let's find best price!", 
                  style: TextStyle(color: Colors.white),
                )
              ),
            ),

            ListTile(
              leading: Icon(Icons.add),
              title: const Text('Add'),
              selected: _selectedIndex == -1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => InputPack(0, "", _onPackModifyTapped, null)
                  )
                );
              },
            ),
            
            for(int i = 0; i < packItems.length; i++)
              ListTile(
                title: Text(packItems[i].name),
                tileColor: _selectedIndex == i ? Colors.black12 : null,
                // selectedTileColor: Colors.grey.shade200,
                onTap: () {
                  _onItemTapped(i);
                  _fetchItemsPrice();
                  Navigator.pop(context); // Close the drawer
                },
              ),
          ],
        ),
      ),
    );
  }
}



class MainScreen extends StatefulWidget {
  final List<ProductPrice> items;
  final int pack_id;
  final String pack_name;
  final Future<void> Function() fetchItemsPrice;
  final Future<void> Function() fetchItemsPack;
  final Future<void> Function(String) onPackModifyTapped;
  final Future<void> Function() deletePack;

  const MainScreen(this.items, this.pack_id, this.pack_name, this.fetchItemsPrice, this.fetchItemsPack, this.onPackModifyTapped, this.deletePack);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  static final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    List<Widget> pinHeaderList = [];

    pinHeaderList.add(
      PackHeader(widget.pack_id, widget.pack_name, null, widget.onPackModifyTapped, widget.deletePack)
    );

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
                    builder: (context) => InputPrice(0, widget.pack_id, 0, 1, 1, "", widget.fetchItemsPrice),
                  ),
                );
              },
            ),
          ),

          // Clear all button
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear'),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Clear data ?'),
                  content: const Text('Clear all data in this note'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await MainScreenState.dbHelper.deleteAllPrice(widget.pack_id);
                        widget.fetchItemsPrice();
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

    return 
      Padding(
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
            
            widget.items.isEmpty
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
                  (context, i) => _ItemList(widget.items[i].id, widget.pack_id, widget.items[i].price, widget.items[i].piece, widget.items[i].quantity, widget.items[i].note, widget.fetchItemsPrice),
                  childCount: widget.items.length,
              ),
            ),
          ],
        )
      );
  }
}

class _ItemList extends StatelessWidget {
  final int id;
  final int pack_id;
  final double price;
  final double piece;
  final double quantity;
  final String note;
  final Future<void> Function() _fetchItems;

  const _ItemList(this.id, this.pack_id, this.price, this.piece, this.quantity, this.note, this._fetchItems);

  @override
  Widget build(BuildContext context) {
    List<Widget> dataRowList = [];

    dataRowList.add(SizedBox(height: 10),);

    dataRowList.add(
      Row(
        children: <Widget>[
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
                      builder: (context) => InputPrice(id, pack_id, price, piece, quantity, note, _fetchItems),
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
                    title: const Text('Delete ?'),
                    content: const Text('Delete data in this row'),
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