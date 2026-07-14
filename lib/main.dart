import 'database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

    // Add button
    elementList.add(
      ElevatedButton.icon(
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
    );

    // list items
    for(var i = 0; i < items.length; i++){
        elementList.add(_ItemList(items[i].id, items[i].price, items[i].piece, items[i].quantity, items[i].note, _fetchItems));
    }

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: elementList
        )
    );
    // Column(children: items.map((item) => _TestTextList(item.id, item.name, item.age)).toList());
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
  final String note;
  final Future<void> Function() _fetchItems;

  // _InputPrice({ Key? key, this.id, this.name, this.age }): super(key: key);
  _InputPrice(this.id, this.price, this.piece, this.quantity, this.note, this._fetchItems);

  @override
 _InputPriceState createState() => _InputPriceState();
  // const _InputPrice(this.id, this.name, this.age);
}

class _InputPriceState extends State<_InputPrice> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController(text: widget.price != null ? widget.price.toString() : '0');
    TextEditingController pieceController = TextEditingController(text: widget.piece != null ? widget.piece.toString() : '1');
    TextEditingController quantityController = TextEditingController(text: widget.quantity != null ? widget.quantity.toString() : '1');
    TextEditingController noteController = TextEditingController(text: widget.note != null ? widget.note : '');

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
              // initialValue: widget.name, //"Test"
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
              // initialValue: widget.age != null ? 'widget.age.toString()' : '',
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
              // initialValue: widget.age != null ? 'widget.age.toString()' : '',
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