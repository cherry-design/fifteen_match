import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/models.dart';
import 'pages/pages.dart';

void main() {
  // Run the app in the fullscreen mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky).then(
    (_) => runApp(const FifteenMatch()),
  );
}

class FifteenMatch extends StatelessWidget {
  const FifteenMatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifteen Match',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          // Just add a little delay to show the splash screen
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashPage();
            } else {
              return FutureBuilder(
                  // Load collections asyncronically
                  future: Storage.loadCollections(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SelectorPage(
                          collections: snapshot.data as List<Collection>);
                    } else {
                      return const SplashPage();
                    }
                  });
            }
          }),
    );
  }
}
