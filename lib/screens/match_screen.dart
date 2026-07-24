import 'dart:math';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/match.dart';
import '../models/player.dart';
import 'ranking_screen.dart';

class MatchScreen extends StatefulWidget {
  final int tournamentId;

  const MatchScreen({
    super.key,
    required this.tournamentId,
  });

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<Player> players = [];
  List<MatchModel> matches = [];

  @override
  void initState() {
    super.initState();
    generateMatches();
  }

 Future<void> generateMatches() async {

  await DatabaseHelper.instance.deleteMatches(widget.tournamentId);

  matches.clear();

  List<Player> currentPlayers =
      await DatabaseHelper.instance
          .getTournamentPlayers(widget.tournamentId);

  players = List.from(currentPlayers);
  if (currentPlayers.length < 2) return;

  Random random = Random();

  int round = 1;

  while (currentPlayers.length > 1) {

    currentPlayers.shuffle();

    List<Player> winners = [];

    for (int i = 0; i < currentPlayers.length; i += 2) {

    if (i + 1 >= currentPlayers.length) {
    winners.add(currentPlayers[i]); 
    continue;
  }

  Player p1 = currentPlayers[i];
  Player p2 = currentPlayers[i + 1];

  if (p1.id == p2.id) {
    continue;
  }

  Player winner = random.nextBool() ? p1 : p2;

  MatchModel match = MatchModel(
    tournamentId: widget.tournamentId,
    player1: p1.id!,
    player2: p2.id!,
    winner: winner.id!,
    round: round,
     );

  await DatabaseHelper.instance.insertMatch(match);

  matches.add(match);

  winners.add(winner);
   }

    currentPlayers = winners;

    round++;
  }

  setState(() {});
}

  String getPlayerName(int id) {
    return players.firstWhere((p) => p.id == id).name;
  }

  String getWinnerName(MatchModel match) {
    return players.firstWhere((p) => p.id == match.winner).name;
  }

  String getChampion() {
  if (matches.isEmpty) {
    return "";
  }

  return getWinnerName(matches.last);
 }

   String getRunnerUp() {
  if (matches.isEmpty) return "";

  MatchModel finalMatch = matches.last;

  int runnerId = finalMatch.player1 == finalMatch.winner
      ? finalMatch.player2
      : finalMatch.player1;

  return getPlayerName(runnerId);
  
 }

String getThirdPlace() {
  if (matches.length < 2) return "";

  MatchModel semiFinal = matches[matches.length - 2];

  int thirdId = semiFinal.player1 == semiFinal.winner
      ? semiFinal.player2
      : semiFinal.player1;

  return getPlayerName(thirdId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tournament Matches"),
      ),
      body: matches.isEmpty
    ? const Center(
        child: Text("Generating Matches..."),
      )
    : Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {

                final match = matches[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      "${getPlayerName(match.player1)} VS ${getPlayerName(match.player2)}",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Round ${match.round}"),

                        Text(
                          "Winner : ${getWinnerName(match)}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.amber.shade100,
            child: Text(
              "🏆 Champion : ${getChampion()}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RankingScreen(
          champion: getChampion(),
          runnerUp: getRunnerUp(),
          thirdPlace: getThirdPlace(),
              ),
             ),
            );
          },
         child: const Text("View Rankings"),
          ),
        ],
      ),
    );
  }
}