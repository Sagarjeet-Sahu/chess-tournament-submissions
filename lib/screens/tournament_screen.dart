import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tournament.dart';
import '../providers/tournament_provider.dart';
import 'assign_players_screen.dart';

class TournamentScreen extends ConsumerStatefulWidget {
  const TournamentScreen({super.key});

  @override
  ConsumerState<TournamentScreen> createState() =>
      _TournamentScreenState();
}

class _TournamentScreenState extends ConsumerState<TournamentScreen> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();

  bool isEditing = false;
  int? editingId;

  void clearFields() {
    nameController.clear();
    locationController.clear();
    dateController.clear();

    editingId = null;
    isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    final tournaments = ref.watch(tournamentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tournaments"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Tournament Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: "Date",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {

                  if (nameController.text.isEmpty ||
                      locationController.text.isEmpty ||
                      dateController.text.isEmpty) {
                    return;
                  }

                  final tournament = Tournament(
                    id: editingId,
                    name: nameController.text,
                    location: locationController.text,
                    date: dateController.text,
                  );

                  if (isEditing) {
                    await ref.read(tournamentProvider.notifier)
                        .updateTournament(tournament);
                  } else {
                    await ref.read(tournamentProvider.notifier)
                        .addTournament(tournament);
                  }

                  setState(() {
                    clearFields();
                  });
                },
                child: Text(
                    isEditing ? "Update Tournament" : "Add Tournament"),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: tournaments.isEmpty
                  ? const Center(
                      child: Text("No Tournaments"),
                    )
                  : ListView.builder(
                      itemCount: tournaments.length,
                      itemBuilder: (context, index) {

                        final tournament = tournaments[index];

                        return Card(
                          child: ListTile(
                            title: Text(tournament.name),
                            subtitle: Text(
                              "${tournament.location}\n${tournament.date}",
                            ),

                           trailing: PopupMenuButton<String>(
                           onSelected: (value) {
                           if (value == "assign") {
                           Navigator.push(
                           context,
                           MaterialPageRoute(
                           builder: (_) => AssignPlayersScreen(
                           tournamentId: tournament.id!,
                           ),
                             ),
                           );
                          } else if (value == "edit") {
                          } else if (value == "delete") {
                           ref
                          .read(tournamentProvider.notifier)
                          .deleteTournament(tournament.id!);
                          } 
                        },
                          itemBuilder: (context) => [
                          const PopupMenuItem(
                          value: "assign",
                          child: Text("Assign Players"),
                            ),
                          const PopupMenuItem(
                          value: "edit",
                          child: Text("Edit"),
                           ),
                           const PopupMenuItem(
                           value: "delete",
                            child: Text("Delete"),
                          ),
                           ],
                           ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}