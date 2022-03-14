import 'dart:math';
import 'package:flutter/material.dart';
import '../models/models.dart';

class BackgroundView extends StatelessWidget {
  const BackgroundView({
    Key? key,
    required this.pieceType,
    required this.colors,
  }) : super(key: key);

  final PieceType pieceType;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        Positioned(
          child: decorationView(),
          top: 15,
          left: -90,
        ),
      ],
    );
  }

  /// DecorationView to show at the top left corner of the background
  Widget decorationView() {
    // Build appropriate decorationView
    Widget decorationView;
    switch (pieceType) {
      case PieceType.square:
        decorationView = _decorationSquareView();
        break;
      case PieceType.squareRound:
        decorationView = _decorationSquareRoundView();
        break;
      case PieceType.squareSize:
        decorationView = _decorationSquareSizeView();
        break;
      case PieceType.roundSize:
        decorationView = _decorationRoundSizeView();
        break;
      case PieceType.roundHalf:
        decorationView = decorationRoundHalfView();
        break;
      case PieceType.roundArrows:
        decorationView = _decorationRoundArrowsView();
        break;
      default:
        decorationView = Container();
    }

    return decorationView;
  }

  /// Square
  Widget _decorationSquareView() {
    return Container(
      width: 330,
      height: 330,
      transform: Matrix4.rotationZ(-15 * pi / 180),
      child: Transform(
        transform: Matrix4.translationValues(-40, 0, 0),
        child: const Text(
          "15",
          softWrap: false,
          style: TextStyle(
            fontSize: 340,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w800,
            letterSpacing: -20,
            color: Color(0x48D8D8D8),
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }

  /// SquareSize
  Widget _decorationSquareSizeView() {
    return Container(
      width: 330,
      height: 330,
      transform: Matrix4.rotationZ(-15 * pi / 180),
      decoration: const BoxDecoration(
        color: Color(0x48D8D8D8),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
    );
  }

  /// SquareRound
  Widget _decorationSquareRoundView() {
    return Container(
      width: 330,
      height: 330,
      transform: Matrix4.rotationZ(-15 * pi / 180),
      child: CustomPaint(
        painter: BackgroundSquareRoundPainter(),
      ),
    );
  }

  /// RoundSize
  Widget _decorationRoundSizeView() {
    return Container(
      width: 330,
      height: 330,
      decoration: const BoxDecoration(
        color: Color(0x48D8D8D8),
        shape: BoxShape.circle,
      ),
    );
  }

  /// RoundArrows
  Widget _decorationRoundArrowsView() {
    return Container(
      width: 330,
      height: 330,
      transformAlignment: Alignment.center,
      transform: Matrix4.rotationZ(75 * pi / 180),
      child: CustomPaint(
        painter: BackgroundArrowPainter(),
      ),
    );
  }

  /// RoundHalf
  Widget decorationRoundHalfView() {
    return Container(
      width: 330,
      height: 330,
      transformAlignment: Alignment.center,
      transform: Matrix4.rotationZ(-15 * pi / 180),
      child: CustomPaint(
        painter: BackgroundHemispherePainter(),
      ),
    );
  }
}

/// Custom painter for Arrow
class BackgroundArrowPainter extends CustomPainter {
  BackgroundArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 60.0
      ..color = const Color(0x48D8D8D8);

    Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height)
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height / 2)
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BackgroundArrowPainter oldDelegate) {
    return false;
  }
}

/// Custom painter for Half
class BackgroundHemispherePainter extends CustomPainter {
  BackgroundHemispherePainter();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x48D8D8D8);

    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Path path = Path()..addArc(rect, pi / 4, pi);
    canvas.drawPath(path, paint);

    paint.color = const Color(0x24D8D8D8);
    path = Path()..addArc(rect, pi / 4, -pi);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BackgroundHemispherePainter oldDelegate) {
    return false;
  }
}

/// Custom painter for SquareRound
class BackgroundSquareRoundPainter extends CustomPainter {
  BackgroundSquareRoundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x48D8D8D8);

    // Create rounded square path
    Rect squareRect = Rect.fromLTWH(0, 0, size.width, size.height);
    Path squarePath = Path()
      ..addRRect(
          RRect.fromRectAndRadius(squareRect, const Radius.circular(30.0)));

    // Create circle hole path
    Rect holeRect = Rect.fromLTWH(size.width * 0.23, size.height * 0.23,
        size.width * 0.54, size.height * 0.54);
    Path holePath = Path()..addOval(holeRect);

    // Create combined path
    Path path = Path.combine(PathOperation.difference, squarePath, holePath);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BackgroundSquareRoundPainter oldDelegate) {
    return false;
  }
}
