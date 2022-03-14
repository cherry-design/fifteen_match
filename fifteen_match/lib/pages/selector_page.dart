import 'dart:ui';
import 'package:flutter/material.dart';
import '../pages/pages.dart';
import '../models/models.dart';

class SelectorPage extends StatefulWidget {
  const SelectorPage({
    Key? key,
    required this.collections,
  }) : super(key: key);

  /// Collections
  final List<Collection> collections;

  @override
  State<SelectorPage> createState() => _SelectorPageState();
}

class _SelectorPageState extends State<SelectorPage> {
  final PageController controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    // List of pages to show
    List<Widget> collectionPages = widget.collections
        .map((collection) => CollectionPage(collection: collection))
        .toList();

    return PageView(
      controller: controller,
      scrollBehavior: CustomScrollBehavior(),
      children: [
        ...collectionPages,
        const AboutPage(),
      ],
    );
  }
}

/// This class is needed to allow drag pages on web build
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
