import 'package:flutter/material.dart';
import 'player_screen.dart';
import 'tournament_screen.dart';


class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title: const Text("chess Tournament"),
      ),
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PlayerScreen(),
            ),
          );
        },
        child: const Text("Players"),
      ),

      const SizedBox(height: 20),

      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TournamentScreen(),
            ),
          );
        },
        child: const Text("Tournaments"),
      ),
    ],
  ),
),
    );
  }
}