import '../models/models.dart';

enum PieceType {
  square,
  squareRound,
  squareSize,
  roundSize,
  roundHalf,
  roundArrows
}

/// Game model
class Game {
  Game({
    required this.gridSize,
    required this.initialData,
  }) {
    // Generating game board
    pieces = [];

    // Check if we have correct initial data
    if (initialData.length == numPieces) {
      // Crrating set of pieces with initial position
      for (var i = 0; i < numPieces; i++) {
        pieces.add(Piece(index: i, value: initialData[i], gridSize: gridSize));
      }

      // Otherwise generate random data
    } else {
      // Generate solved position
      for (var i = 0; i < numPieces; i++) {
        pieces.add(Piece(index: i, value: i, gridSize: gridSize));
      }

      // Shuffle pieces
      shuffle();
    }
  }

  /// Size of the board
  final int gridSize;

  /// Initial level data
  final List<int> initialData;

  /// List of [Piece]s representing the game's current state
  List<Piece> pieces = [];

  /// Type of the piece to draw
  final PieceType pieceType = PieceType.values.first;

  /// Number of the steps
  int steps = 0;

  /// Time spent in seconds
  int time = 0;

  /// Total number of the pieces
  int get numPieces {
    return gridSize * gridSize;
  }

  /// Find empty piece
  Piece _getEmptyPiece() {
    return pieces.singleWhere((piece) => piece.isEmpty);
  }

  /// Number of inversions
  int get _inversions {
    Piece emptyPiece = _getEmptyPiece();
    var inversions = 0;
    for (var i = 0; i < pieces.length; i++) {
      if (pieces[i] == emptyPiece) {
        continue;
      }
      for (var j = i + 1; j < pieces.length; j++) {
        if (pieces[i].value > pieces[j].value && pieces[j] != emptyPiece) {
          inversions += 1;
        }
      }
    }
    return inversions;
  }

  /// Determines if the position is Solvable
  bool get _isSolvable {
    Piece emptyPiece = _getEmptyPiece();

    // If the grid dimension is odd, then the puzzle
    // solved if the number of inversions is even
    if (gridSize % 2 == 1) {
      return _inversions % 2 == 0;
    }

    // Find the Y-coordinate of an empty cell, counting from the bottom
    int yEmptyFromBottom = gridSize - emptyPiece.index ~/ gridSize;

    // If the grid dimension is even, then the puzzle
    // solved if an empty cell is in an even row
    // and the number of inversions is odd or vice versa
    if (yEmptyFromBottom % 2 == 1) {
      return _inversions % 2 == 0;
    } else {
      return _inversions % 2 == 1;
    }
  }

  /// Determines if the game is Solved
  bool get isSolved {
    // Calculate the total number of correctly placed pieces
    int numCorrectPieces =
        pieces.fold(0, (value, piece) => value + (piece.isCorrect ? 1 : 0));

    // Checking that all pieces are in place
    return numCorrectPieces == numPieces;
  }

  /// Randomize position of the pieces
  void shuffle() {
    // Shuffle pieces for a resolvable position
    do {
      // Shuffle pieces
      pieces.shuffle();

      // Updating pieces indeces
      for (var i = 0; i < pieces.length; i++) {
        pieces[i] = Piece(index: i, value: pieces[i].value, gridSize: gridSize);
      }
    } while (!_isSolvable);

    // Reset number of the steps
    steps = 0;
  }

  /// Moves piece
  bool move(Piece piece) {
    Piece emptyPiece = _getEmptyPiece();

    // Finding the current position of tje empty Piece
    int xEmpty = emptyPiece.index % gridSize;
    int yEmpty = emptyPiece.index ~/ gridSize;

    // Find the pieces around an empty piece which can be moved
    List<Piece> allowedPieces = [];
    if (xEmpty - 1 >= 0) {
      allowedPieces.add(pieces[emptyPiece.index - 1]);
    }
    if (xEmpty + 1 < gridSize) {
      allowedPieces.add(pieces[emptyPiece.index + 1]);
    }
    if (yEmpty - 1 >= 0) {
      allowedPieces.add(pieces[emptyPiece.index - gridSize]);
    }
    if (yEmpty + 1 < gridSize) {
      allowedPieces.add(pieces[emptyPiece.index + gridSize]);
    }

    // Check if the pressed piece can be moved
    if (allowedPieces.contains(piece)) {
      pieces[piece.index] = Piece(
          index: piece.index, value: emptyPiece.value, gridSize: gridSize);
      pieces[emptyPiece.index] = Piece(
          index: emptyPiece.index, value: piece.value, gridSize: gridSize);

      // Increase counter
      steps++;

      return true;
    }

    return false;
  }
}
