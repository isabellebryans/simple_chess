import 'package:flutter/material.dart';
import 'package:simple_chess/my_chess.dart';
import 'package:simple_chess_board/models/board_arrow.dart';
import 'package:chess/chess.dart' as chesslib;
import 'package:simple_chess_board/simple_chess_board.dart';
import 'package:simple_chess/apply_shacl.dart';

void main() {
  runApp(const MyApp());
}

late String prevFen;
late String currentFen;
late ShortMove most_recent_move;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple chess board Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Simple chess board Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _chess = chesslib.Chess.fromFEN(chesslib.Chess.DEFAULT_POSITION);

  var _blackAtBottom = false;
  BoardArrow? _lastMoveArrowCoordinates;
  late ChessBoardColors _boardColors;

  @override
  void initState() {
    currentFen = _chess.fen;
    _boardColors = ChessBoardColors()
      ..lightSquaresColor = Colors.blue.shade200
      ..darkSquaresColor = Colors.blue.shade600
      ..coordinatesZoneColor = Colors.redAccent.shade200
      ..lastMoveArrowColor = Colors.cyan
      ..selectionHighlightColor = Colors.orange
      ..circularProgressBarColor = Colors.red
      ..coordinatesColor = Colors.green;
    super.initState();
  }

  void saveFen(String fen) {
    print("saveFen");
    prevFen = fen;
  }

  void update_fen() {}

  bool check_shacl(ShortMove move, String fen) {
    return true;
  }

  void change_turn() {
    setState(() {
      _chess.turn = _chess.turn == chesslib.Color.WHITE
          ? chesslib.Color.BLACK
          : chesslib.Color.WHITE;
    });
  }

// reset fen
  void fake_undo() {
    currentFen = prevFen;
    _chess.load(currentFen);
  }

  void move_made({required ShortMove move}) {
    // first save the fen
    saveFen(_chess.fen);
    // make temp move for shacl
    int intfrom = chesslib.Chess.SQUARES[move.from];
    int intto = chesslib.Chess.SQUARES[move.to];
    _chess.board[intto] = _chess.board[intfrom];
    _chess.board[intfrom] = null;
    change_turn();
    // now chess board has wrong fen

    // verify this fen and move in shacl
    if (check_shacl(move, _chess.fen)) {
      print("shacl approves");
    } else {
      print("shacl disapproves");
    }
    // show move made regardless of shacl approval
    setState(() {
      currentFen = _chess.fen;
    });

    // ideally set state here and wait a bit

    // reset chess board
    _chess.load(prevFen);

    // properly try chess move
    final success = _chess.move(<String, String?>{
      'from': move.from,
      'to': move.to,
      'promotion': move.promotion.toNullable()?.name,
    });
    if (success) {
      //change_turn();
      print("Valid move");

      setState(() {});
    } else {
      print("invalid move");
      setState(() {
        currentFen = _chess.fen;
      });
    }

    // reset app, showing move if it was valid
    //setState(() {});
  }

  Future<PieceType?> handlePromotion(BuildContext context) {
    final navigator = Navigator.of(context);
    return showDialog<PieceType>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Promotion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Queen"),
                onTap: () => navigator.pop(PieceType.queen),
              ),
              ListTile(
                title: const Text("Rook"),
                onTap: () => navigator.pop(PieceType.rook),
              ),
              ListTile(
                title: const Text("Bishop"),
                onTap: () => navigator.pop(PieceType.bishop),
              ),
              ListTile(
                title: const Text("Knight"),
                onTap: () => navigator.pop(PieceType.knight),
              ),
            ],
          ),
        );
      },
    );
  }

// implement button to validate last 3 moves with shacl
  @override
  Widget build(BuildContext context) {
    final boardOrientation =
        _blackAtBottom ? BoardColor.black : BoardColor.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _blackAtBottom = !_blackAtBottom;
              });
            },
            icon: const Icon(Icons.swap_vert),
          )
        ],
      ),
      body: Row(
        children: [
          Center(
            child: SimpleChessBoard(
              engineThinking: false,
              fen: currentFen,
              onMove: ({required ShortMove move}) {
                print('${move.from}|${move.to}|${move.promotion}');
                move_made(move: move);
                // make floating button to validate move, board and last 3 moves
                // if pressed: undo fake move, do real move with chesslib
              },
              orientation: BoardColor.white,
              chessBoardColors: _boardColors,
              whitePlayerType: PlayerType.human,
              blackPlayerType: PlayerType.human,
              lastMoveToHighlight: _lastMoveArrowCoordinates,
              onPromote: () => handlePromotion(context),
              onPromotionCommited: ({required ShortMove moveDone}) =>
                  {print(moveDone)},
            ),
          ),
          Expanded(
            child: FloatingActionButton.extended(
              onPressed: () {
                // Add your onPressed code here!#
                print(fetchAlbum());
              },
              label: const Text('Echeque et mate!!!!!'),
              icon: const Icon(Icons.thumb_down),
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
