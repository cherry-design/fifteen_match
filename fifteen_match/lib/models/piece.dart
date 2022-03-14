import 'dart:math';

/// Piece model
class Piece {
  final int index;
  final int value;
  final int gridSize;

  const Piece({
    required this.index,
    required this.value,
    required this.gridSize,
  });

  /// Determines if piece is in the correct position
  bool get isCorrect {
    return index == value;
  }

  /// Determines if piece is empty
  bool get isEmpty {
    return value == (gridSize * gridSize - 1);
  }

  /// The distance between the value of the piece and its current position
  int get length {
    // Finding the correct position
    int xCorrect = value % gridSize;
    int yCorrect = value ~/ gridSize;

    // Finding the current position
    int x = index % gridSize;
    int y = index ~/ gridSize;

    // Calculate the distance using a simplified scheme,
    // just taking the largest cathetus - this is enough for a square grid
    int length = max((x - xCorrect).abs(), (y - yCorrect).abs());

    return length;
  }

  /// Function for calculating the distance between the piece value and its current position along the X axis
  int get lengthX {
    // Finding the correct X-position
    int xCorrect = value % gridSize;

    // Finding the current X-position
    int x = index % gridSize;

    // Calculate the distance along the X axis
    int lengthX = (x - xCorrect).abs();

    return lengthX;
  }

  /// Function for calculating the distance between the piece value and its current position along the Y axis
  int get lengthY {
    // Finding the correct Y-position
    int yCorrect = value ~/ gridSize;

    // Finding the current Y-position
    int y = index ~/ gridSize;

    // Calculate the distance along the X axis
    int lengthY = (y - yCorrect).abs();

    return lengthY;
  }

  /// Function for angle directed to the correct piece position
  double get angle {
    // Finding the correct position
    int xCorrect = value % gridSize;
    int yCorrect = value ~/ gridSize;

    // Finding the current position
    int x = index % gridSize;
    int y = index ~/ gridSize;

    // Calculate the distances along the axes
    int lengthX = xCorrect - x;
    int lengthY = yCorrect - y;

    // Calculate unit vectors
    int directionX = lengthX > 0 ? 1 : (lengthX < 0 ? -1 : 0);
    int directionY = lengthY > 0 ? 1 : (lengthY < 0 ? -1 : 0);

    // Calculate angle
    double angle = atan2(directionX, -directionY);

    return angle;
  }
}
