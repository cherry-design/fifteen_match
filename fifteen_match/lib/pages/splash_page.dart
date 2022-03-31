import 'package:flutter/material.dart';
import '../views/views.dart';
import '../models/models.dart';
import '../typography/typography.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  /// Title and description
  final String title = "Match";
  final String subtitle = "New flavour of the famous game";

  @override
  Widget build(BuildContext context) {
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
              child: LayoutBuilder(builder: (context, constraints) {
                return Align(
                  alignment: Alignment.bottomLeft,
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomLeft,
                    heightFactor: constraints.maxHeight < Layout.maxHeight
                        ? 1
                        : Layout.verticalRatio,
                    child: Row(
                      children: [
                        SizedBox(
                            width: constraints.maxWidth < Layout.maxWidth
                                ? 0
                                : Layout.leftPadding),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _headerView(),
                            Builder(builder: (context) {
                              if (constraints.maxHeight < Layout.maxHeight) {
                                return const SizedBox(height: 150);
                              } else {
                                return const Spacer();
                              }
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
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
              subtitle,
              style: TextStyles.subtitle.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
