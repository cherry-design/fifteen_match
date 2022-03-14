import 'package:flutter/material.dart';

enum PaletteTheme { light, dark }

/// Palette model
class Palette {
  final String id;
  final String name;
  final PaletteTheme theme;
  final List<Color> colors;
  final List<Color> gradient;

  const Palette({
    required this.id,
    required this.name,
    required this.theme,
    required this.colors,
    required this.gradient,
  });

  /// Get PaletteTheme from String
  static PaletteTheme _paletteThemeFromString(String string) {
    for (PaletteTheme value in PaletteTheme.values) {
      if (value.toString() == "PaletteTheme." + string) {
        return value;
      }
    }
    return PaletteTheme.values.first;
  }

  // JSON decoder
  factory Palette.fromJson(Map<String, dynamic> json) {
    return Palette(
      id: json['id'] as String,
      name: json['name'] as String,
      theme: _paletteThemeFromString(json['theme']),
      colors: (json['colors'] as List<dynamic>)
          .map((hexValue) => Color(int.parse(hexValue)))
          .toList(),
      gradient: (json['gradient'] as List<dynamic>)
          .map((hexValue) => Color(int.parse(hexValue)))
          .toList(),
    );
  }

  /// Calculate a set of colors for a specific gridSize
  List<Color> gameColors({required int gridSize}) {
    if (gridSize == 3) {
      return [
        colors[0],
        colors[2],
        colors[3],
      ];
    } else if (gridSize == 4) {
      return colors.sublist(0, 4);
    } else {
      return colors;
    }
  }

  /// Main color for the text
  Color get mainColor {
    return (theme == PaletteTheme.light) ? Colors.black : Colors.white;
  }

  /// Alternate color for the text
  Color get alternateColor {
    return (theme == PaletteTheme.light) ? Colors.white : Colors.black;
  }

  /// Background overlay semitransparent color
  Color get overlayColor {
    double opacity = (theme == PaletteTheme.light) ? 0.5 : 0.25;
    return Colors.white.withOpacity(opacity);
  }

  /// Opacity for subtitle text
  double get subtitleOpacity {
    return (theme == PaletteTheme.light) ? 0.7 : 0.6;
  }
}
