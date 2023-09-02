class Move {
  final String from;
  final String to;
  final String? captured;

  const Move({
    required this.from,
    required this.to,
    this.captured,
  });
}
