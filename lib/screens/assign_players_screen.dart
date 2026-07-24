import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/player.dart';
import 'match_screen.dart';

class AssignPlayersScreen extends StatefulWidget {
  final int tournamentId;

  const AssignPlayersScreen({
    super.key,
    required this.tournamentId,
  });

  @override
  State<AssignPlayersScreen> createState() => _AssignPlayersScreenState();
}

class _AssignPlayersScreenState extends State<AssignPlayersScreen> {
  List<Player> players = [];
  Set<int> selectedPlayers = {};

  @override
  void initState() {
    super.initState();
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    players = await DatabaseHelper.instance.getPlayers();
    setState(() {});
  }

  Future<void> savePlayers() async {
    for (int id in selectedPlayers) {
      await DatabaseHelper.instance.addPlayerToTournament(
        widget.tournamentId,
        id,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Players Assigned Successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Players"),
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {

                final player = players[index];

                return CheckboxListTile(
                  value: selectedPlayers.contains(player.id),

                  title: Text(player.name),

                  subtitle: Text(
                    "Rating : ${player.rating}",
                  ),

                  onChanged: (value) {

                    setState(() {

                      if (value!) {
                        selectedPlayers.add(player.id!);
                      } else {
                        selectedPlayers.remove(player.id);
                      }

                    });

                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: savePlayers,
                child: const Text("Save Players"),
              ),
            ),
          ),
          ElevatedButton(
          onPressed: () {

          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (_) => MatchScreen(
          tournamentId: widget.tournamentId,
        ),
      ),
    );

  },
  child: const Text("Start Tournament"),
) 
        ],
      ),
    );
  }
}