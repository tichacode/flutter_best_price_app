import 'screen_main_drawer.dart';
import 'database_helper.dart';
import 'package:flutter/material.dart';

class InputPrice extends StatefulWidget {
  final int id;
  final int pack_id;
  final double price;
  final double piece;
  final double quantity;
  final String? note;
  final Future<void> Function() _fetchItems;

  InputPrice(this.id, this.pack_id, this.price, this.piece, this.quantity, this.note, this._fetchItems);

  @override
 _InputPriceState createState() => _InputPriceState();
}

class _InputPriceState extends State<InputPrice> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController priceController = TextEditingController();
  TextEditingController pieceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    priceController.dispose();
    pieceController.dispose();
    quantityController.dispose();
    noteController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    priceController.text = widget.price.toString();
    pieceController.text = widget.piece.toString();
    quantityController.text = widget.quantity.toString();
    noteController.text = widget.note ?? '';

    return Scaffold(
      appBar: AppBar(title: TITLE_TEXT),
      resizeToAvoidBottomInset: true,
      body: 
      SingleChildScrollView(
        child: Padding(
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
                        if (value == null || value.isEmpty || num.tryParse(value) == null) {
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
                    validator: (value) {
                        if (value == null || value.isEmpty || num.tryParse(value) == null) {
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
                    validator: (value) {
                        if (value == null || value.isEmpty || num.tryParse(value) == null) {
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
                  
                  // Save
                  FloatingActionButton.extended(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var priceData = ProductPrice(id: widget.id, price: double.parse(priceController.text), piece: double.parse(pieceController.text), quantity: double.parse(quantityController.text), note: noteController.text);
                        if (widget.id == 0) {
                          await MainScreenState.dbHelper.addPrice(priceData, widget.pack_id);
                        } else {
                          await MainScreenState.dbHelper.updatePrice(priceData);
                        }

                        widget._fetchItems();

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    label: const Text('Save')
                  ),

                  const SizedBox(height: 40.0),

                  // Cancel
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
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


class InputPack extends StatefulWidget {
  final int id;
  final String? name;
  final Future<void> Function(String) _onPackModifyTapped;
  final Future<void> Function()? _refreshPack;

  InputPack(this.id, this.name, this._onPackModifyTapped, this._refreshPack); //, this._fetchItems

  @override
  _InputPackState createState() => _InputPackState();
}

class _InputPackState extends State<InputPack> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.name ?? '';

    return Scaffold(
      appBar: AppBar(title: TITLE_TEXT),
      resizeToAvoidBottomInset: true,
      body: 
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: _formKey,
              child:  Column(
                mainAxisAlignment: .center,
                children: <Widget>[

                  // Name
                  Container(
                    margin: const EdgeInsets.only(top:25.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[Expanded(child: Text("Note name : "))]),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Note price',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.0),

                  // Save
                  FloatingActionButton.extended(
                    onPressed: () async {
                      if (nameController.text == "") {
                        nameController.text = "Note price";
                      }
                      
                      var packData = PackPrice(id: widget.id, name: nameController.text);
                      
                      if (widget.id == 0) {
                        await MainScreenState.dbHelper.addPack(packData);
                        widget._onPackModifyTapped("Create");
                      } else {
                        await MainScreenState.dbHelper.updatePack(packData);
                        widget._onPackModifyTapped("Update");
                      }

                      widget._refreshPack?.call();

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    label: const Text('Save')
                  ),

                  // Cancel
                  const SizedBox(height: 40.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
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