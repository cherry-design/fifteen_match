import 'package:flutter/material.dart';
import '../views/views.dart';
import '../models/models.dart';
import '../typography/typography.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  /// Title and description
  final String title = "Match";
  final String description = "New flavour of the famous game";

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundView(
            pieceType: PieceType.square,
            colors: [Colors.black, Colors.black],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  SizedBox(
                      width: orientation == Orientation.portrait ? 0 : 250),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerView(),
                      SizedBox(
                          height:
                              orientation == Orientation.portrait ? 278 : 140),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Header view
  Widget _headerView() {
    // Palette
    List<Color> colors = const [
      Color(0xff405952),
      Color(0xff9C9B7A),
      Color(0xffFFD393),
      Color(0xffFF974F),
      Color(0xffF54F29),
    ];

    // List of colors to show
    List<Widget> colorTiles = colors
        .map((color) => Container(width: 37, height: 12, color: color))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.title.copyWith(color: Colors.white),
        ),
        Row(
          children: colorTiles,
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            const SizedBox(width: 3),
            Text(
              description,
              style: TextStyles.subtitle.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
