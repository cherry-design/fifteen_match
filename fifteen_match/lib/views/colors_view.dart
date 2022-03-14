import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../models/models.dart';
import '../typography/text_styles.dart';

class ColorsView extends StatelessWidget {
  const ColorsView({
    Key? key,
    required this.gridSize,
    required this.pieceType,
    required this.palette,
  }) : super(key: key);

  /// The size of the board
  final int gridSize;

  /// Type of the piece to draw
  final PieceType pieceType;

  /// Current palette
  final Palette palette;

  /// Base size of the color container
  static const double size = 35;

  @override
  Widget build(BuildContext context) {
    // List of colors to show
    List<Widget> colorTiles = palette
        .gameColors(gridSize: gridSize)
        .mapIndexed((index, color) => _colorView(index: index, color: color))
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Correct",
              style: TextStyles.small.copyWith(color: palette.mainColor)),
          Row(children: colorTiles),
          Text("Wrong",
              style: TextStyles.small.copyWith(color: palette.mainColor)),
        ],
      ),
      decoration: BoxDecoration(
        color: palette.overlayColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
    );
  }

  /// Color view
  Widget _colorView({required int index, required Color color}) {
    // Calculate scale
    double scale = 1.0;
    if (pieceType == PieceType.squareSize || pieceType == PieceType.roundSize) {
      scale = 1 - 0.1 * index;
    }

    return Container(
      // DEBUG -  пока непонятно нужно ли делать зазор или нет
      // margin: const EdgeInsets.symmetric(horizontal: 2.0),
      width: size * scale,
      height: size * scale,
      color: color,
    );
  }
}
