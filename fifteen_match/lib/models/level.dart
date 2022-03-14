/// Level model
class Level {
  final int id;
  final int gridSize;
  final List<int> data;
  bool isSolved;

  Level({
    required this.id,
    required this.gridSize,
    required this.data,
    this.isSolved = false,
  });

  // JSON decoder
  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] as int,
      gridSize: json['gridSize'] as int,
      data:
          (json['data'] as List<dynamic>).map((value) => value as int).toList(),
    );
  }
}
