import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/pages.dart';
import '../views/views.dart';
import '../models/models.dart';
import '../typography/typography.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  /// Title and version of the app
  final String title = "Match";
  final String version = "Version 1.0.0";

  final String developerUrl = "https://www.cherry-design.com/";

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  static const String prefMusicOnKey = 'musicOn';
  static const String prefSoundOnKey = 'soundOn';

  // Play music flag
  bool _musicOn = true;

  // Play sound flag
  bool _soundOn = true;

  @override
  void initState() {
    super.initState();

    // Load settings from shared preferences
    _loadSettings();
  }

  // Load settings from shared preferences
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load music preference
    if (prefs.containsKey(prefMusicOnKey)) {
      setState(() {
        _musicOn = prefs.getBool(prefMusicOnKey) ?? true;
      });
    }

    // Load sound preference
    if (prefs.containsKey(prefSoundOnKey)) {
      setState(() {
        _soundOn = prefs.getBool(prefSoundOnKey) ?? true;
      });
    }
  }

  // Toggle music
  void _toggleMusic() async {
    setState(() {
      _musicOn = !_musicOn;
    });

    // Update preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(prefMusicOnKey, _musicOn);
  }

  // Toggle sound
  void _toggleSound() async {
    setState(() {
      _soundOn = !_soundOn;
    });

    // Update preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(prefSoundOnKey, _soundOn);
  }

  // Show music copyrights
  void _showCopyrights() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const CopyrightsPage();
        },
      ),
    );
  }

  // Open developer website
  void _openDeveloperWebsite() async {
    if (!await launch(
      widget.developerUrl,
      forceWebView: false,
      forceSafariVC: false,
    )) {
      throw 'Could not launch ${widget.developerUrl}';
    }
  }

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
                      const SizedBox(height: 25),
                      _settingsView(),
                      SizedBox(
                          height:
                              orientation == Orientation.portrait ? 160 : 28),
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
          widget.title,
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
              widget.version,
              style: TextStyles.subtitle,
            ),
          ],
        ),
      ],
    );
  }

  /// Settings view
  Widget _settingsView() {
    return SizedBox(
        height: 55,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _settingsButton(
              _musicOn ? Icons.music_note : Icons.music_off,
              onTap: _toggleMusic,
            ),
            _settingsButton(
              _soundOn ? Icons.volume_up : Icons.volume_off,
              onTap: _toggleSound,
            ),
            _settingsButton(
              Icons.man,
              onTap: _showCopyrights,
            ),
            _settingsButton(
              Icons.language,
              onTap: _openDeveloperWebsite,
            ),
          ],
        ));
  }

  /// Settings button
  Widget _settingsButton(IconData iconData, {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 43,
        height: 43,
        alignment: Alignment.center,
        child: Icon(iconData, size: 30),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black, width: 3),
          shape: BoxShape.circle,
        ),
      ),
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
