import 'package:flutter/material.dart';
import '../views/views.dart';
import '../models/models.dart';
import '../typography/typography.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  // Version of the app
  final String version = "Version 1.0.0";

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundView(
            pieceType: PieceType.square,
            colors: [Colors.white, Colors.white],
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
                              orientation == Orientation.portrait ? 238 : 110),
                      _copyrightView(),
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
          "Match",
          style: TextStyles.title,
        ),
        Row(
          children: colorTiles,
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            const SizedBox(width: 3),
            Text(
              version,
              style: TextStyles.subtitle,
            ),
          ],
        ),
      ],
    );
  }

  /// Copyright view
  Widget _copyrightView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Programming & Design",
          style: TextStyles.small,
        ),
        const SizedBox(height: 3),
        Text(
          "2022 © Studio \"Cherry-Design\"",
          style: TextStyles.small.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
