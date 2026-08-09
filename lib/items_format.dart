import 'package:flutter/material.dart';

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
                // WidgetSpan(
                //   child: Icon(Icons.monetization_on_rounded, size: 14),
                // ),
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
                // WidgetSpan(
                //   child: Icon(Icons.monetization_on_rounded, size: 14),
                // ),
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
                // WidgetSpan(
                //   child: Icon(Icons.monetization_on_rounded, size: 14),
                // ),
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
                // WidgetSpan(
                //   child: Icon(Icons.monetization_on_rounded, size: 14),
                // ),
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