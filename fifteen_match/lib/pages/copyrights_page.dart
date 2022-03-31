import 'package:flutter/material.dart';
import '../views/views.dart';
import '../models/models.dart';
import '../typography/typography.dart';

class CopyrightsPage extends StatefulWidget {
  const CopyrightsPage({Key? key}) : super(key: key);

  /// Title and description
  final String title = "Music";
  final String description = "Copyright attribution";

  @override
  State<CopyrightsPage> createState() => _CopyrightsPageState();
}

class _CopyrightsPageState extends State<CopyrightsPage> {
  @override
  Widget build(BuildContext context) {
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
              child: LayoutBuilder(builder: (context, constraints) {
                return Row(
                  children: [
                    SizedBox(
                        width: constraints.maxWidth < Layout.maxWidth
                            ? 0
                            : Layout.leftPadding),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _headerView(),
                        const SizedBox(height: 25),
                        Expanded(
                          child: SizedBox(
                            width: constraints.maxWidth < Layout.maxWidth
                                ? constraints.maxWidth
                                : constraints.maxWidth - Layout.leftPadding,
                            child: _copyrightsView(),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Header
  Widget _headerView() {
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Visibility(
                    // DEBUG
                    visible: screenHeight <= 700 &&
                        orientation == Orientation.portrait,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12, right: 12),
                      child: _backButton(),
                    )),
                Text(
                  widget.title,
                  style: TextStyles.title,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 18),
              child: _iconInfo(),
            ),
          ],
        ),
        Text(
          widget.description,
          style: TextStyles.subtitle,
        ),
        Visibility(
            visible: screenHeight > 700 || orientation == Orientation.landscape,
            child: _backButton()),
      ],
    );
  }

  /// Back button
  Widget _backButton() {
    return Transform(
      transform: Matrix4.translationValues(-8, 0, 0),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => {Navigator.pop(context)},
        icon: const Icon(
          Icons.arrow_back_rounded,
          size: 60.0,
          color: Colors.black,
        ),
      ),
    );
  }

  /// Icon info
  Widget _iconInfo() {
    return Container(
      width: 43,
      height: 43,
      alignment: Alignment.center,
      child: const Icon(Icons.man, size: 30),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.black, width: 3),
        shape: BoxShape.circle,
      ),
    );
  }

  /// Copyrights view
  Widget _copyrightsView() {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: Storage.loadCopyrights(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data as String,
                style: TextStyles.small,
              );
            } else {
              return const Text("File not found");
            }
          }),
    );
  }
}
