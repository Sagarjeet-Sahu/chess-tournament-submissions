import 'package:flutter/material.dart';

class RankingScreen extends StatelessWidget {
  final String champion;
  final String runnerUp;
  final String thirdPlace;

  const RankingScreen({
    super.key,
    required this.champion,
    required this.runnerUp,
    required this.thirdPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tournament Rankings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Text(
                  "🥇",
                  style: TextStyle(fontSize: 28),
                ),
                title: Text(
                  champion,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text("Champion"),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Text(
                  "🥈",
                  style: TextStyle(fontSize: 28),
                ),
                title: Text(
                runnerUp,
                style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
               ),
            ),
                subtitle: const Text("Runner Up"),
         ),
     ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Text(
                  "🥉",
                  style: TextStyle(fontSize: 28),
                ),
               title: Text(
               thirdPlace,
               style: const TextStyle(
               fontSize: 20,
               fontWeight: FontWeight.bold,
                ),
              ),
                subtitle: const Text("Third Place"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}