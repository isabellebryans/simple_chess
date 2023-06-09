class Move {
  final String from;
  final String to;
  final String piece;
  final int boardStatus;

  const Move({
    required this.from,
    required this.to,
    required this.piece,
    required this.boardStatus,
  });
}
