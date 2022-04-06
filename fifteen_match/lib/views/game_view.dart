import 'package:flutter/material.dart';
import '../models/models.dart';
import '../views/views.dart';

class GameView extends StatelessWidget {
  const GameView({
    Key? key,
    required this.gridSize,
    required this.pieces,
    required this.palette,
    required this.onClick,
    required this.onDrag,
    required this.pieceType,
    required this.showNumbers,
    required this.isSolved,
  }) : super(key: key);

  /// The size of the board
  final int gridSize;

  /// The pieces to be displayed on the board
  final List<Piece> pieces;

  /// The current palette
  final Palette palette;

  /// Called when this piece is tapped
  final Function(Piece piece) onClick;

  /// Called when this piece is dragged
  final Function(Piece, DragUpdateDetails details) onDrag;

  /// Type of the piece to draw
  final PieceType pieceType;

  /// Flag to show value of the piece
  final bool showNumbers;

  /// Flag to show the puzzle is solved
  final bool isSolved;

  /// The spacing between each piece
  double get spacing {
    double spacing = 11 - 2 * (gridSize - 3);
    return spacing;
  }

  @override
  Widget build(BuildContext context) {
    // List of the pieces to show
    List<Widget> piecesTiles = pieces
        .map((piece) => AnimatedSwitcher(
              // DEBUG
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: PieceView(
                key: ValueKey(piece.isEmpty),
                piece: piece,
                colors: palette.gameColors(gridSize: gridSize),
                pieceType: pieceType,
                showNumbers: showNumbers || piece.isCorrect,
                isSolved: isSolved,
                onClick: () => onClick(piece),
                onDrag: (details) => onDrag(piece, details),
              ),
            ))
        .toList();

    return GridView.count(
      padding: EdgeInsets.zero,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: gridSize,
      children: piecesTiles,
      clipBehavior: Clip.none,
    );
  }
}
