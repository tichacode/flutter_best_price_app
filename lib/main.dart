import 'database_helper.dart';
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

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  static final dbHelper = DatabaseHelper();
  List<ProductPrice> items = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    //test: dbHelper.addPrice(ProductPrice(id: 0, price: 0, piece: 1, quantity: 1, note: "test"));
    final data = await dbHelper.fetchPrice();
    setState(() {
      items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> elementList = [];

    // Add and clear all button
    elementList.add(
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
                    builder: (context) => _InputPrice(0, 0, 1, 1, "", _fetchItems),
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
                        await _MainScreenState.dbHelper.deleteAllPrice();
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
    elementList.add(
      Row(
        children: <Widget>[
          // Add button
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Price ",
                  ),
                  WidgetSpan(
                    child: Icon(Icons.monetization_on_rounded, size: 14),
                  ),
                ],
              ),
            )
          ),

          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Piece ",
                  ),
                  WidgetSpan(
                    child: Icon(Icons.question_mark, size: 14),
                  ),
                ],
              ),
            )
          ),

          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Quantity ",
                  ),
                  WidgetSpan(
                    child: Icon(Icons.water_drop_rounded, size: 14),
                  ),
                ],
              ),
            )
          ),
        ]
      )
    );

    // list items
    if (items.isEmpty) {
      elementList.add(const SizedBox(height: 20), );
    } else {
      for(var i = 0; i < items.length; i++){
          elementList.add(_ItemList(items[i].id, items[i].price, items[i].piece, items[i].quantity, items[i].note, _fetchItems));
      }
    }

    elementList.add(
      ElevatedButton.icon(
        // icon: const Icon(Icons.add),
        label: const Text('Calculate!'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => ResultScreen(),
            ),
          );
        },
      ),
    );

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20.0,
            children: elementList
            )
        )
    );
  }
}

class _ItemList extends StatelessWidget {
  final int id;
  final int price;
  final int piece;
  final int quantity;
  final String note;
  final Future<void> Function() _fetchItems;

  const _ItemList(this.id, this.price, this.piece, this.quantity, this.note, this._fetchItems);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // Expanded(
        //   child: Text(id.toString(), textAlign: TextAlign.center),
        // ),
        Expanded(
          child: Text(price.toString(), textAlign: TextAlign.center),
        ),
        Expanded(
          child: Text(piece.toString(), textAlign: TextAlign.center),
        ),
        Expanded(
          child: Text(quantity.toString(), textAlign: TextAlign.center),
        ),
        Expanded(
          child: Text(note, textAlign: TextAlign.center),
        ),

        // Edit button
        IconButton (
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => _InputPrice(id, price, piece, quantity, note, _fetchItems),
              ),
            );
          },
        ),

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
                    await _MainScreenState.dbHelper.deletePrice(id);
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
      ]
    );
  }
}

class _InputPrice extends StatefulWidget {
  final int id;
  final int price;
  final int piece;
  final int quantity;
  final String? note;
  final Future<void> Function() _fetchItems;

  _InputPrice(this.id, this.price, this.piece, this.quantity, this.note, this._fetchItems);

  @override
 _InputPriceState createState() => _InputPriceState();
}

class _InputPriceState extends State<_InputPrice> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController(text: widget.price.toString());
    TextEditingController pieceController = TextEditingController(text: widget.piece.toString());
    TextEditingController quantityController = TextEditingController(text: widget.quantity.toString());
    TextEditingController noteController = TextEditingController(text: widget.note ?? '');

    return Scaffold(
      body: //Container()
         Form(
          key: _formKey,
      child: Column(
          mainAxisAlignment: .center,
          children: <Widget>[

            // Price
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Please write a name',
              ),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                      return 'Enter valid data';
                  }
                  return null;
              },
            ),
            
            // Piece
            TextFormField(
              controller: pieceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Please write a piece',
              ),
              inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
              validator: (value) {
                  if (value == null || value.isEmpty) {
                      return 'Enter valid data';
                  }
                  return null;
              },
            ),

            // Quantity
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Please write a quantity',
              ),
              inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
              validator: (value) {
                  if (value == null || value.isEmpty) {
                      return 'Enter valid data';
                  }
                  return null;
              },
            ),

            // Note
            TextFormField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'Please write a note',
              ),
            ),

            const SizedBox(height: 40.0),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var priceData = ProductPrice(id: widget.id, price: int.parse(priceController.text), piece: int.parse(pieceController.text), quantity: int.parse(quantityController.text), note: noteController.text);
                  if (widget.id == 0) {
                    await _MainScreenState.dbHelper.addPrice(priceData);
                  } else {
                    await _MainScreenState.dbHelper.updatePrice(priceData);
                  }

                  widget._fetchItems();

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Save')
            ),

            const SizedBox(height: 40.0),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('cancel'),
            ),
          ],
        )
        )
    );
  }
}


class ResultScreen extends StatelessWidget {
  // final int? id;
  // final String? name;
  // final int? age;

  // const ResultScreen(this.id, this.name, this.age);
  const ResultScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result screen (test)')),
      body: 
      Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}