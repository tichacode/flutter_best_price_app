// https://medium.com/@valerii.novykov/how-to-create-custom-dashed-and-dotted-dividers-in-flutter-a3cbe637fb86
// extension: dash and dotted dividers

import 'package:flutter/material.dart';

class DividerThemeProvider {
  final DividerThemeData _dividerTheme;
  final ThemeData _theme;
  final DividerThemeData _defaults;

  double? _width;
  double? _height;
  double? _thickness;
  double? _indent;
  double? _endIndent;
  Color? _color;

  DividerThemeProvider._(BuildContext context)
      : _dividerTheme = DividerTheme.of(context),
        _theme = Theme.of(context),
        _defaults = Theme.of(context).useMaterial3
            ? _DividerDefaultsM3(context)
            : _DividerDefaultsM2(context);

  static DividerThemeProvider of(BuildContext context) {
    return DividerThemeProvider._(context);
  }

  DividerThemeProvider withDefaults({
    double? width,
    double? height,
    double? thickness,
    double? indent,
    double? endIndent,
    Color? color,
  }) {
    _width = width ?? _width;
    _height = height ?? _height;
    _thickness = thickness ?? _thickness;
    _indent = indent ?? _indent;
    _endIndent = endIndent ?? _endIndent;
    _color = color ?? _color;

    return this;
  }

  double get width => _width ?? _dividerTheme.space ?? _defaults.space!;

  double get height => _height ?? _dividerTheme.space ?? _defaults.space!;

  double get thickness =>
      _thickness ?? _dividerTheme.thickness ?? _defaults.thickness!;

  double get indent => _indent ?? _dividerTheme.indent ?? _defaults.indent!;

  double get endIndent =>
      _endIndent ?? _dividerTheme.endIndent ?? _defaults.endIndent!;

  Color get color =>
      _color ?? _dividerTheme.color ?? _defaults.color ?? _theme.dividerColor;
}

class _DividerDefaultsM3 extends DividerThemeData {
  const _DividerDefaultsM3(this.context)
      : super(
          space: 16,
          thickness: 1.0,
          indent: 0,
          endIndent: 0,
        );

  final BuildContext context;

  @override
  Color? get color => Theme.of(context).colorScheme.outlineVariant;
}

class _DividerDefaultsM2 extends DividerThemeData {
  const _DividerDefaultsM2(this.context)
      : super(
          space: 16,
          thickness: 0,
          indent: 0,
          endIndent: 0,
        );

  final BuildContext context;

  @override
  Color? get color => Theme.of(context).dividerColor;
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double dashLength;
  final double dashSpace;
  final bool isVertical;
  final double mainAxisOffset;

  DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.dashLength,
    required this.dashSpace,
    this.isVertical = false,
    this.mainAxisOffset = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness <= 0 ? 1 : thickness;

    final mainAxisSize = _getMainAxisSize(size);
    final crossAxisPosition = _getCrossAxisPosition(size);

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    double currentPosition = mainAxisOffset;

    while (currentPosition < mainAxisSize) {
      double nextDashEnd = currentPosition + dashLength;

      if (nextDashEnd > mainAxisSize) {
        nextDashEnd = mainAxisSize;
      }

      final start = _calculateStartOffset(crossAxisPosition, currentPosition);
      final end = _calculateEndOffset(crossAxisPosition, nextDashEnd);

      canvas.drawLine(start, end, paint);

      currentPosition += dashLength + dashSpace;
    }
  }

  double _getMainAxisSize(Size size) {
    return isVertical ? size.height : size.width;
  }

  double _getCrossAxisPosition(Size size) {
    return isVertical ? size.width / 2 : size.height / 2;
  }

  Offset _calculateStartOffset(
      double crossAxisPosition, double currentPosition) {
    return isVertical
        ? Offset(crossAxisPosition, currentPosition)
        : Offset(currentPosition, crossAxisPosition);
  }

  Offset _calculateEndOffset(double crossAxisPosition, double nextDashEnd) {
    return isVertical
        ? Offset(crossAxisPosition, nextDashEnd)
        : Offset(nextDashEnd, crossAxisPosition);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DashedDivider extends StatelessWidget {
  /// The divider's height extent.
  ///
  /// The divider itself is always drawn as a horizontal line that is centered
  /// within the height specified by this value.
  ///
  /// If this is null, then the [DividerThemeData.space] is used. If that is
  /// also null, then this defaults to 16.0.
  final double? height;

  /// The thickness of the line drawn within the divider.
  ///
  /// A divider with a [thickness] of 0.0 is always drawn as a line with a
  /// height of exactly one device pixel.
  ///
  /// If this is null, then the [DividerThemeData.thickness] is used. If
  /// that is also null, then this defaults to 0.0.
  final double? thickness;

  /// The amount of empty space to the leading edge of the divider.
  ///
  /// If this is null, then the [DividerThemeData.indent] is used. If that is
  /// also null, then this defaults to 0.0.
  final double? indent;

  /// The amount of empty space to the trailing edge of the divider.
  ///
  /// If this is null, then the [DividerThemeData.endIndent] is used. If that is
  /// also null, then this defaults to 0.0.
  final double? endIndent;

  /// The color to use when painting the line.
  ///
  /// If this is null, then the [DividerThemeData.color] is used. If that is
  /// also null, then [ThemeData.dividerColor] is used.
  final Color? color;

  /// The length of each dash in the dashed line.
  final double dashLength;

  /// The space between each dash in the dashed line.
  final double dashSpace;

  /// The offset along the main axis for the starting position of the dashes.
  ///
  /// This value determines how far from the start the first dash will be drawn,
  /// allowing for fine-tuning the positioning of the dashed line. A positive value
  /// shifts the dashes forward, while a negative value moves them backward along
  /// the main axis.
  ///
  /// The default value is 0.0, meaning the dashes start at the beginning of the line.
  final double mainAxisOffset;

  const DashedDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
    this.dashLength = 5,
    this.dashSpace = 5,
    this.mainAxisOffset = 0.0,
  })  : assert(height == null || height >= 0.0),
        assert(thickness == null || thickness >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0);

  @override
  Widget build(BuildContext context) {
    final theme = DividerThemeProvider.of(context).withDefaults(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );

    return Container(
      margin: EdgeInsets.only(left: theme.indent, right: theme.endIndent),
      height: theme.height,
      width: double.infinity,
      child: CustomPaint(
        painter: DashedLinePainter(
          color: theme.color,
          thickness: theme.thickness,
          dashLength: dashLength,
          dashSpace: dashSpace,
          mainAxisOffset: mainAxisOffset,
        ),
      ),
    );
  }
}