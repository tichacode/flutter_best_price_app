import 'screen_main_drawer.dart';
import 'screen_input.dart';
import 'package:flutter/material.dart';

// header first row: pack name, edit button, delete button
class PackHeader extends StatelessWidget {
  final int pack_id;
  final String pack_name;
  final Future<void> Function()? _refreshPack;
  final Future<void> Function(String) _onPackModifyTapped;
  final Future<void> Function() _deletePack;

  const PackHeader(this.pack_id, this.pack_name, this._refreshPack, this._onPackModifyTapped, this._deletePack);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 84,
          child: Text(pack_name, style: TextStyle(fontSize: 25)),
        ),

        // Edit button
        Expanded(
          flex: 8,
          child:
            IconButton (
              icon: const Icon(Icons.edit, color: Colors.grey,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => InputPack(pack_id, pack_name, _onPackModifyTapped, _refreshPack),
                  ),
                );
              },
            ),
        ),

        // Delete button
        Expanded(
          flex: 8,
          child: 
            IconButton (
              icon: const Icon(Icons.delete, color: Colors.grey,),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete this note ?'),
                  content: const Text('all of data in this note will disappear.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _deletePack();
                        await _onPackModifyTapped("Delete");
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<void>(
                              builder: (context) => const MainScreenDrawer(),
                            ),
                            (route) => false,
                          );
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
    );
  }
}

// hearder data part for main and result page
class DataHeader extends StatelessWidget {
  final int flex_gap_first;
  final int flex_price;
  final int flex_piece;
  final int flex_quantity;
  final int flex_price_per_unit;
  final int flex_gap_last;

  const DataHeader(this.flex_gap_first, this.flex_price, this.flex_piece, this.flex_quantity, this.flex_price_per_unit, this.flex_gap_last);

  @override
  Widget build(BuildContext context) {
    List<Widget> headerList = [];
    double gap_height = 10;
    final headerStyle = DefaultTextStyle.of(context).style.copyWith(
      fontWeight: FontWeight.normal,
    );

    // gap first
    if (flex_gap_first != 0) {
      headerList.add(
        Expanded(
          flex: flex_gap_first,
          child: 
            SizedBox(height: gap_height),
        ),
      );
    }

    // price
    if (flex_price != 0) {
      headerList.add(
        Expanded(
          flex: flex_price,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: headerStyle,
              children: [
                TextSpan(
                  text: "Price",
                ),
              ],
            ),
          )
        ),
      );
    }

    // piece
    if (flex_piece != 0) {
      headerList.add(
        Expanded(
          flex: flex_piece,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: headerStyle,
              children: [
                TextSpan(
                  text: "Piece",
                ),
              ],
            ),
          )
        ),
      );
    }

    // quantity
    if (flex_quantity != 0) {
      headerList.add(
        Expanded(
          flex: flex_quantity,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: headerStyle,
              children: [
                TextSpan(
                  text: "Quantity",
                ),
              ],
            ),
          )
        ),
      );
    }

    // price per unit
    if (flex_price_per_unit != 0) {
      headerList.add(
        Expanded(
          flex: flex_price_per_unit,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: headerStyle,
              children: [
                TextSpan(
                  text: "Price per unit",
                ),
              ],
            ),
          )
        ),
      );
    }

    // gap last
    if (flex_gap_last != 0) {
      headerList.add(
        Expanded(
          flex: flex_gap_last,
          child: 
            SizedBox(height: gap_height),
        ),
      );
    }

    return Row(
        children: headerList
    );
  }
}