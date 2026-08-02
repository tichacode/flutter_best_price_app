import 'screen_result.dart';
import 'database_helper.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';


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
    elementList.add(
      Row(
        children: <Widget>[
          // header: price
          Expanded(
            flex: 28,
            child: RichText(
              textAlign: TextAlign.center,
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

          // header: piece
          Expanded(
            flex: 28,
            child: RichText(
              textAlign: TextAlign.center,
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

          // header: quantity
          Expanded(
            flex: 28,
            child: RichText(
              textAlign: TextAlign.center,
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

          // gap in header
          Expanded(
            flex: 16,
            child: 
            // ColoredBox(
            //   color: Colors.blue,
            //   child: 
              SizedBox(height: 10,),
            // )
          )
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
      // Calculate button
      ElevatedButton.icon(
        label: const Text('Calculate!'),
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
        }
      ),
    );

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
                      builder: (context) => _InputPrice(id, price, piece, quantity, note, _fetchItems),
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


class _InputPrice extends StatefulWidget {
  final int id;
  final double price;
  final double piece;
  final double quantity;
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
                  } else if (double.parse(value) < 0) {
                    return 'Price value must not less than 0';
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
              // inputFormatters: <TextInputFormatter>[
              //       FilteringTextInputFormatter.digitsOnly
              //     ],
              validator: (value) {
                  if (value == null || value.isEmpty) {
                      return 'Enter valid data';
                  } else if (double.parse(value) < 0) {
                    return 'Piece value must not less than 0';
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
              // inputFormatters: <TextInputFormatter>[
              //       FilteringTextInputFormatter.digitsOnly
              //     ],
              validator: (value) {
                  if (value == null || value.isEmpty) {
                      return 'Enter valid data';
                  } else if (double.parse(value) < 0) {
                    return 'Quantity value must not less than 0';
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
                  var priceData = ProductPrice(id: widget.id, price: double.parse(priceController.text), piece: double.parse(pieceController.text), quantity: double.parse(quantityController.text), note: noteController.text);
                  if (widget.id == 0) {
                    await MainScreenState.dbHelper.addPrice(priceData);
                  } else {
                    await MainScreenState.dbHelper.updatePrice(priceData);
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