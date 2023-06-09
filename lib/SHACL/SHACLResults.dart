class SHACLResults {
  final int TT;
  final int CR;
  final int TS;
  final int boardStatus;

  const SHACLResults({
    required this.TT,
    required this.TS,
    required this.CR,
    required this.boardStatus,
  });

  factory SHACLResults.fromJson(Map<String, dynamic> json) {
    return SHACLResults(
        TT: json['TT'],
        CR: json['CR'],
        TS: json['TS'],
        boardStatus: json['boardStatus']);
  }
}
