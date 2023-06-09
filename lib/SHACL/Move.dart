class Move {
  final String from;
  final String to;
  final String piece;
  final String? captured;

  const Move({
    required this.from,
    required this.to,
    required this.piece,
    this.captured,
  });
}
