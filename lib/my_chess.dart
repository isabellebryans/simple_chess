import 'package:chess/chess.dart';

/// Returns a FEN String representing the current position
String generate_my_fen(List<Piece?> board, ColorMap<int> castling, Color turn,
    int? ep_square, int half_moves, int move_number) {
  var empty = 0;
  var fen = '';

  for (var i = Chess.SQUARES_A8; i <= Chess.SQUARES_H1; i++) {
    if (board[i] == null) {
      empty++;
    } else {
      if (empty > 0) {
        fen += empty.toString();
        empty = 0;
      }
      var color = board[i]!.color;
      PieceType? type = board[i]!.type;

      fen += (color == Chess.WHITE) ? type.toUpperCase() : type.toLowerCase();
    }

    if (((i + 1) & 0x88) != 0) {
      if (empty > 0) {
        fen += empty.toString();
      }

      if (i != Chess.SQUARES_H1) {
        fen += '/';
      }

      empty = 0;
      i += 8;
    }
  }

  var cflags = '';
  if ((castling[Chess.WHITE] & Chess.BITS_KSIDE_CASTLE) != 0) {
    cflags += 'K';
  }
  if ((castling[Chess.WHITE] & Chess.BITS_QSIDE_CASTLE) != 0) {
    cflags += 'Q';
  }
  if ((castling[Chess.BLACK] & Chess.BITS_KSIDE_CASTLE) != 0) {
    cflags += 'k';
  }
  if ((castling[Chess.BLACK] & Chess.BITS_QSIDE_CASTLE) != 0) {
    cflags += 'q';
  }

  /* do we have an empty castling flag? */
  if (cflags == '') {
    cflags = '-';
  }
  final epflags =
      (ep_square == Chess.EMPTY) ? '-' : Chess.algebraic(ep_square!);
  final turnStr = (turn == Color.WHITE) ? 'w' : 'b';

  return [fen, turnStr, cflags, epflags, half_moves, move_number].join(' ');
}
