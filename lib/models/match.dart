class MatchModel {
  int? id;
  int tournamentId;
  int player1;
  int player2;
  int winner;
  int round;

  MatchModel({
    this.id,
    required this.tournamentId,
    required this.player1,
    required this.player2,
    required this.winner,
    required this.round,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "tournamentId": tournamentId,
      "player1": player1,
      "player2": player2,
      "winner": winner,
      "round": round,
    };
  }

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: map["id"],
      tournamentId: map["tournamentId"],
      player1: map["player1"],
      player2: map["player2"],
      winner: map["winner"],
      round: map["round"],
    );
  }
}