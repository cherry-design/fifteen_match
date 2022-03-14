import 'dart:math';
import 'package:flutter/material.dart';
import '../models/models.dart';

class PieceView extends StatelessWidget {
  const PieceView({
    Key? key,
    required this.piece,
    required this.colors,
    required this.onClick,
    required this.onDrag,
    required this.pieceType,
    required this.showNumbers,
    required this.isSolved,
  }) : super(key: key);

  /// Current piece
  final Piece piece;

  /// The colors using for calculate piece color
  final List<Color> colors;

  /// Called when this piece is tapped
  final VoidCallback onClick;

  /// Called when this piece is dragged
  final Function(DragUpdateDetails details) onDrag;

  /// Type of the piece to draw
  final PieceType pieceType;

  /// Flag to show value of the piece
  final bool showNumbers;

  /// Flag to show the puzzle is solved
  final bool isSolved;

  // Scale on the X-axis
  double get scaleX {
    // Calculate difference
    int lengthX = piece.lengthX;

    // Calculate scale
    double scaleX = 1.0 - lengthX * 0.15;
    return scaleX;
  }

  // Scale on the Y-axis
  double get scaleY {
    // Calculate difference
    int lengthY = piece.lengthY;

    // Calculate scale
    double scaleY = 1.0 - lengthY * 0.15;
    return scaleY;
  }

  // Color on the X-axis
  Color get colorX {
    // Calculate difference
    int lengthX = piece.lengthX;

    // Calculate color
    Color color = lengthX < colors.length ? colors[lengthX] : Colors.grey;
    return color;
  }

  // Color on the Y-axis
  Color get colorY {
    // Calculate difference
    int lengthY = piece.lengthY;

    // Calculate color
    Color color = lengthY < colors.length ? colors[lengthY] : Colors.grey;
    return color;
  }

  // Color on both axis
  Color get color {
    // Calculate difference
    int length = piece.length;

    // Calculate color
    Color color = length < colors.length ? colors[length] : Colors.grey;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    if (piece.isEmpty && !isSolved) {
      return _emptyPieceView();
    }

    // Build appropriate pieceView
    Widget pieceView;
    switch (pieceType) {
      case PieceType.square:
        pieceView = _pieceSquareView();
        break;
      case PieceType.squareRound:
        pieceView = _pieceSquareRoundView();
        break;
      case PieceType.squareSize:
        pieceView = _pieceSquareSizeView();
        break;
      case PieceType.roundSize:
        pieceView = _pieceRoundSizeView();
        break;
      case PieceType.roundHalf:
        pieceView = _pieceRoundHalfView();
        break;
      case PieceType.roundArrows:
        pieceView = _pieceRoundArrowsView();
        break;
      default:
        pieceView = _emptyPieceView();
    }

    // Wrap with GestureDetector
    return GestureDetector(
      onTap: onClick,
      onPanUpdate: onDrag,
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: [
          pieceView,
          // Show value of the piece if needed
          showNumbers
              ? Center(
                  child: Text(
                    "${piece.value + 1}",
                    style: const TextStyle(
                      fontSize: 36,
                      // DEBUG
                      //fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  /// Square
  Widget _pieceSquareView() {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        boxShadow: const [BoxShadow(blurRadius: 5.0, color: Color(0x60000000))],
      ),
    );
  }

  /// SquareRound
  Widget _pieceSquareRoundView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorX,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            boxShadow: const [
              BoxShadow(blurRadius: 5.0, color: Color(0x60000000))
            ],
          ),
        ),
        Transform.scale(
          scale: 0.5,
          transformHitTests: false,
          child: Container(
            decoration: BoxDecoration(
              color: colorY,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  /// SquareSize
  Widget _pieceSquareSizeView() {
    return Transform.scale(
      scale: scaleY,
      transformHitTests: false,
      child: Container(
        decoration: BoxDecoration(
          color: colorX,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          boxShadow: const [
            BoxShadow(blurRadius: 5.0, color: Color(0x60000000))
          ],
        ),
      ),
    );
  }

  /// RoundSize
  Widget _pieceRoundSizeView() {
    return Transform.scale(
      scale: scaleY,
      transformHitTests: false,
      child: Container(
        decoration: BoxDecoration(
          color: colorX,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(blurRadius: 5.0, color: Color(0x60000000))
          ],
        ),
      ),
    );
  }

  /// RoundHalf
  Widget _pieceRoundHalfView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorX,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(blurRadius: 5.0, color: Color(0x60000000))
            ],
          ),
        ),
        CustomPaint(
          painter: HemisheperePainter(color: color),
        ),
      ],
    );
  }

  /// RoundArrows
  Widget _pieceRoundArrowsView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(blurRadius: 5.0, color: Color(0x60000000))
            ],
          ),
        ),
        piece.isCorrect
            ? const SizedBox()
            : Transform.rotate(
                angle: piece.angle,
                child: CustomPaint(
                  painter: ArrowPainter(),
                ),
              )
      ],
    );
  }

  /// Empty
  Widget _emptyPieceView() {
    return const SizedBox();
  }
}

/// Custom painter for Hemishere
class HemisheperePainter extends CustomPainter {
  HemisheperePainter({required this.color});

  // Color of the hemishere
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Path path = Path()..addArc(rect, pi / 4, pi);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HemisheperePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// Custom painter for Arrow
class ArrowPainter extends CustomPainter {
  ArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width / 14
      ..color = Colors.white;

    Path path = Path()
      ..moveTo(size.width / 2, size.width / 4)
      ..lineTo(size.width / 2, size.height * 3 / 4)
      ..moveTo(size.width / 2, size.width / 4)
      ..lineTo(size.width / 4, size.height / 2)
      ..moveTo(size.width / 2, size.width / 4)
      ..lineTo(size.width * 3 / 4, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return false;
  }
}
