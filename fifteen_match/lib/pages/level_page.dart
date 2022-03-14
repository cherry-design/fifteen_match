import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../typography/text_styles.dart';
import '../views/views.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({
    Key? key,
    required this.collection,
    required this.index,
  }) : super(key: key);

  /// Collection
  final Collection collection;

  /// Index of the initial level
  final int index;

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  // Main game object
  late Game game;

  // Index of the current level
  late int index;

  // Main timer
  Timer? timer;
  bool timerActive = false;

  @override
  void initState() {
    super.initState();

    // Initialize index
    index = widget.index;

    // Initialize game object
    _initGame();

    // Start timer
    _updateTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// Current level
  Level get level {
    return widget.collection.levels[index];
  }

  /// Initialize game object with current level
  void _initGame() {
    game = Game(
      gridSize: level.gridSize,
      initialData: level.data,
    );
  }

  /// Handle timer events
  void _updateTimer() {
    timer = Timer(const Duration(seconds: 1), _updateTimer);
    if (timerActive) {
      // Update spent time
      setState(() {
        game.time++;
      });
    }
  }

  /// Format time string to H:mm:ss
  String _timeFormat(int time) {
    // Calculate hours, minutes and seconds
    int hours = time ~/ 3600;
    int minutes = (time - hours * 3600) ~/ 60;
    int seconds = (time - hours * 3600) % 60;

    // Calculate time string
    String timeString = "";
    if (hours > 0) {
      timeString += hours.toString() + ":";
    }

    if (timeString.isNotEmpty && minutes < 10) {
      timeString += "0";
    }
    timeString += minutes.toString() + ":";

    if (timeString.isNotEmpty && seconds < 10) {
      timeString += "0";
    }
    timeString += seconds.toString();

    return timeString;
  }

  /// Handle clicked piece
  void _onClickPiece(Piece piece) {
    setState(() {
      // Set flag to start timer
      if (!timerActive) {
        timerActive = true;
      }

      // Trying to move piece
      game.move(piece);
    });

    // Checking if the puzzle is solved
    if (game.isSolved) {
      setState(() {
        timerActive = false;
        level.isSolved = true;
      });

      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Excellent Job!'),
          content: Text(
              'You solved the puzzle using\n ${game.steps} moves in ${_timeFormat(game.time)}.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Repeat');
                setState(() {
                  // Reset game
                  game.shuffle();
                  game.steps = 0;
                  game.time = 0;
                });
              },
              child: const Text('Repeat'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Next');
                setState(() {
                  // Forward to next level
                  index = (index < widget.collection.levels.length - 1)
                      ? index + 1
                      : 0;
                  _initGame();
                });
              },
              child: const Text('Next'),
            ),
          ],
        ),
      );
    }
  }

  /// Handle dragged piece
  void _onDragPiece(Piece piece, DragUpdateDetails details) {
    double dx = details.delta.dx;
    double dy = details.delta.dy;

    // Index of the piece to check
    int checkIndex = piece.index;

    if (dx.abs() > dy.abs()) {
      // Horizontal drag
      checkIndex += dx.sign.toInt();
    } else {
      // Vertical drag
      checkIndex += dy.sign.toInt() * piece.gridSize;
    }

    // Checking if we are dragging a piece into an empty slot
    if (checkIndex >= 0 && checkIndex < piece.gridSize * piece.gridSize) {
      Piece checkPiece = game.pieces[checkIndex];
      if (checkPiece.isEmpty) {
        // If we drag a piece to an empty slot, then the move is allowed
        _onClickPiece(piece);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Stack(children: [
        BackgroundView(
          pieceType: widget.collection.pieceType,
          colors: widget.collection.palette.gradient,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Builder(
              builder: (BuildContext context) {
                if (orientation == Orientation.portrait) {
                  return _portraitView();
                } else {
                  return _landscapeView();
                }
              },
            ),
          ),
        )
      ]),
    );
  }

  /// Portrait view of the game
  Widget _portraitView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _headerView(),
        Column(
          children: [
            _stepsAndTimerView(),
            const SizedBox(height: 28),
            GameView(
              gridSize: game.gridSize,
              pieces: game.pieces,
              palette: widget.collection.palette,
              pieceType: widget.collection.pieceType,
              showNumbers: widget.collection.showNumbers,
              isSolved: game.isSolved,
              onClick: _onClickPiece,
              onDrag: _onDragPiece,
            ),
          ],
        ),
        ColorsView(
            gridSize: game.gridSize,
            pieceType: widget.collection.pieceType,
            palette: widget.collection.palette),
      ],
    );
  }

  /// Landscape view of the game
  Widget _landscapeView() {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerView(),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Text(
                  widget.collection.instructions,
                  style: TextStyles.body.copyWith(
                    color: widget.collection.palette.mainColor,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _stepsAndTimerView(),
                  const SizedBox(height: 10),
                  ColorsView(
                      gridSize: game.gridSize,
                      pieceType: widget.collection.pieceType,
                      palette: widget.collection.palette),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 50),
        Expanded(
          flex: 1,
          child: GameView(
            gridSize: game.gridSize,
            pieces: game.pieces,
            palette: widget.collection.palette,
            pieceType: widget.collection.pieceType,
            showNumbers: widget.collection.showNumbers,
            isSolved: game.isSolved,
            onClick: _onClickPiece,
            onDrag: _onDragPiece,
          ),
        ),
      ],
    );
  }

  /// Header
  Widget _headerView() {
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    // Get current level
    Level level = widget.collection.levels[index];

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
                    visible: screenHeight <= 700 &&
                        orientation == Orientation.portrait,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12, right: 12),
                      child: _backButton(),
                    )),
                Text(
                  widget.collection.name,
                  style: TextStyles.title.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _levelNumber(number: level.id, highlight: level.isSolved),
            ),
          ],
        ),
        Text(
          widget.collection.palette.name,
          style: TextStyles.subtitle.copyWith(
            color: Colors.white
                .withOpacity(widget.collection.palette.subtitleOpacity),
          ),
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
          color: Colors.white,
        ),
      ),
    );
  }

  /// Steps and timer
  Widget _stepsAndTimerView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoView(icon: Icons.sports_score, text: "${game.steps}"),
        _infoView(icon: Icons.timer_outlined, text: _timeFormat(game.time))
      ],
    );
  }

  /// Information view with icon and text
  Widget _infoView({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 32,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Text(text, style: TextStyles.label.copyWith(color: Colors.white)),
      ],
    );
  }

  /// Level number
  Widget _levelNumber({required int number, bool highlight = false}) {
    return Container(
      width: 43,
      height: 43,
      alignment: Alignment.center,
      child: Text(
        "${number + 1}",
        style: TextStyles.number.copyWith(
          color: highlight ? Colors.black : Colors.white,
        ),
      ),
      decoration: BoxDecoration(
        color: highlight ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.white, width: 3),
        shape: BoxShape.circle,
      ),
    );
  }
}
