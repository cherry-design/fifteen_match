import '../models/models.dart';

/// Collection model
class Collection {
  final String id;
  final String name;
  final String instructions;
  final PieceType pieceType;
  final bool showNumbers;
  final Palette palette;
  final List<Level> levels;

  const Collection({
    required this.id,
    required this.name,
    required this.instructions,
    required this.pieceType,
    required this.showNumbers,
    required this.palette,
    required this.levels,
  });

  /// Get PieceType from String
  static PieceType _pieceTypeFromString(String string) {
    for (PieceType value in PieceType.values) {
      if (value.toString() == "PieceType." + string) {
        return value;
      }
    }
    return PieceType.values.first;
  }

  /// JSON decoder
  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String,
      name: json['name'] as String,
      instructions: json['instructions'] as String,
      pieceType: _pieceTypeFromString(json['pieceType']),
      showNumbers: json['showNumbers'] as bool,
      palette: Palette.fromJson(json['palette'] as Map<String, dynamic>),
      levels: (json['levels'] as List<dynamic>)
          .map((level) => Level.fromJson(level as Map<String, dynamic>))
          .toList(),
    );
  }
}
