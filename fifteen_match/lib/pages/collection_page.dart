import 'dart:math';

import 'package:flutter/material.dart';
import '../pages/pages.dart';
import '../models/models.dart';
import '../typography/typography.dart';
import '../views/views.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({
    Key? key,
    required this.collection,
  }) : super(key: key);

  /// Collection to show
  final Collection collection;

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  /// Level select handler
  void _goToNextLevel({required int index}) {
    // Find first not solved level in case index is negative
    if (index < 0) {
      Level nextLevel = widget.collection.levels.firstWhere(
          (level) => level.isSolved == false,
          orElse: () => widget.collection.levels.first);

      // Find index of the first not solved level
      int nextIndex = widget.collection.levels.indexOf(nextLevel);
      index = (nextIndex == -1) ? 0 : nextIndex;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LevelPage(collection: widget.collection, index: index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        BackgroundView(
          pieceType: widget.collection.pieceType,
          colors: widget.collection.palette.gradient,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(builder: (context, constraints) {
              Orientation orientation =
                  constraints.maxHeight > constraints.maxWidth
                      ? Orientation.portrait
                      : Orientation.landscape;
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
                          const SizedBox(height: 25),
                          Visibility(
                            visible: orientation == Orientation.portrait,
                            child: SizedBox(
                              width: constraints.maxWidth < Layout.maxWidth
                                  ? 0.75 * constraints.maxWidth
                                  : 0.75 * constraints.maxWidth -
                                      Layout.leftPadding,
                              child: Text(
                                widget.collection.instructions,
                                style: TextStyles.body.copyWith(
                                  color: widget.collection.palette.mainColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  orientation == Orientation.portrait ? 35 : 0),
                          SizedBox(
                              width: constraints.maxWidth < Layout.maxWidth
                                  ? constraints.maxWidth
                                  : min(
                                      constraints.maxWidth - Layout.leftPadding,
                                      Layout.maxWidthLevels),
                              child: _levelsView(
                                  levels: widget.collection.levels)),
                          Builder(builder: (context) {
                            if (constraints.maxHeight < Layout.maxHeight) {
                              return const SizedBox(height: 27);
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
        )
      ]),
    );
  }

  /// Header view
  Widget _headerView() {
    // List of colors to show
    List<Widget> colorTiles = widget.collection.palette.colors
        .map((color) => Container(width: 37, height: 12, color: color))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.collection.name,
              style: TextStyles.title.copyWith(
                color: widget.collection.palette.mainColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => _goToNextLevel(index: -1),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: 60.0,
                  color: widget.collection.palette.mainColor,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: colorTiles,
        ),
        const SizedBox(height: 7),
        Text(
          widget.collection.palette.name,
          style: TextStyles.subtitle.copyWith(
            color: Colors.white
                .withOpacity(widget.collection.palette.subtitleOpacity),
          ),
        ),
      ],
    );
  }

  /// Levels
  Widget _levelsView({required List<Level> levels}) {
    List<Widget> levelsTiles = levels
        .map((level) =>
            _levelButton(number: level.id, highlight: level.isSolved))
        .toList();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: levelsTiles,
    );
  }

  /// Level button
  Widget _levelButton({required int number, bool highlight = false}) {
    // Get the main and alternate colors
    Color mainColor = widget.collection.palette.mainColor;
    Color alternateColor = widget.collection.palette.alternateColor;

    return GestureDetector(
      onTap: () => _goToNextLevel(index: number),
      child: Container(
        width: 43,
        height: 43,
        alignment: Alignment.center,
        child: Text(
          "${number + 1}",
          style: TextStyles.number.copyWith(
            color: highlight ? alternateColor : mainColor,
          ),
        ),
        decoration: BoxDecoration(
          color: highlight ? mainColor : Colors.transparent,
          border: Border.all(color: mainColor, width: 3),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
