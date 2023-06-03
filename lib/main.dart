import 'package:flutter/material.dart';
import 'package:simple_chess/my_chess.dart';
import 'package:simple_chess_board/models/board_arrow.dart';
import 'package:chess/chess.dart' as chesslib;
import 'package:simple_chess_board/simple_chess_board.dart';

void main() {
  runApp(const MyApp());
}

late String prevFen;
late String currentFen;

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

  bool check_shacl({required ShortMove move}) {
    return true;
  }

  void FakeMove({required ShortMove move}) {
    print(move.from);
    //print(_chess.board[123]?.type);
    //update fen

    print(chesslib.Chess.SQUARES[move.from]);
    int intfrom = chesslib.Chess.SQUARES[move.from];
    int intto = chesslib.Chess.SQUARES[move.to];
    _chess.board[intto] = _chess.board[intfrom];
    _chess.board[intfrom] = null;
    //currentFen = _chess.generate_fen();
    print(currentFen);
    currentFen = generate_my_fen(_chess.board, _chess.castling, _chess.turn,
        _chess.ep_square, _chess.half_moves, _chess.move_number);
    print(currentFen);
    setState(() {});
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
      body: Center(
        child: SimpleChessBoard(
          engineThinking: false,
          fen: currentFen,
          onMove: ({required ShortMove move}) {
            print('${move.from}|${move.to}|${move.promotion}');
            // save previous fen
            saveFen(currentFen);
            // make fake move
            // change fen
            FakeMove(move: move);
            // check if shacl allows
            if (check_shacl(move: move)) {
              // shacl accepts it
              // then check real move
              print("shacl accepts!");
            }
            // make floating button to validate move
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
    );
  }
}
