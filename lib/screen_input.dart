import 'screen_main.dart';
import 'database_helper.dart';
import 'package:flutter/material.dart';

class InputPrice extends StatefulWidget {
  final int id;
  final double price;
  final double piece;
  final double quantity;
  final String? note;
  final Future<void> Function() _fetchItems;

  InputPrice(this.id, this.price, this.piece, this.quantity, this.note, this._fetchItems);

  @override
 _InputPriceState createState() => _InputPriceState();
}

class _InputPriceState extends State<InputPrice> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController(text: widget.price.toString());
    TextEditingController pieceController = TextEditingController(text: widget.piece.toString());
    TextEditingController quantityController = TextEditingController(text: widget.quantity.toString());
    TextEditingController noteController = TextEditingController(text: widget.note ?? '');

    return Scaffold(
      appBar: AppBar(title: const Text('Find Best Price!')),
      resizeToAvoidBottomInset: true,
      body: 
      SingleChildScrollView(
        child: Padding(
        // padding: EdgeInsets.only(right:20.0, left: 20.0, top:20.0, bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: _formKey,
              child:  Column(
                mainAxisAlignment: .center,
                children: <Widget>[
                  // Price
                  Container(
                    margin: const EdgeInsets.only(top:25.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[Expanded(child: Text("Price : "))]),
                  ),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Please write a name',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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
                  Container(
                    margin: const EdgeInsets.only(top:25.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[Expanded(child: Text("Piece : "))]),
                  ),
                  TextFormField(
                    controller: pieceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Please write a piece',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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
                  Container(
                    margin: const EdgeInsets.only(top:25.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[Expanded(child: Text("Quantity : "))]),
                  ),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Please write a quantity',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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
                  Container(
                    margin: const EdgeInsets.only(top:25.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[Expanded(child: Text("Note : "))]),
                  ),
                  TextFormField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: 'Please write a note',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.0),

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
          )
        )
      )
    );
  }
}