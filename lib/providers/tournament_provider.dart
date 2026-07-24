import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_helper.dart';
import '../models/tournament.dart';

final tournamentProvider =
    StateNotifierProvider<TournamentNotifier, List<Tournament>>((ref) {
  return TournamentNotifier();
});

class TournamentNotifier extends StateNotifier<List<Tournament>> {
  TournamentNotifier() : super([]) {
    loadTournaments();
  }

  Future<void> loadTournaments() async {
    state = await DatabaseHelper.instance.getTournaments();
  }

  Future<void> addTournament(Tournament tournament) async {
    await DatabaseHelper.instance.insertTournament(tournament);
    await loadTournaments();
  }

  Future<void> updateTournament(Tournament tournament) async {
    await DatabaseHelper.instance.updateTournament(tournament);
    await loadTournaments();
  }

  Future<void> deleteTournament(int id) async {
    await DatabaseHelper.instance.deleteTournament(id);
    await loadTournaments();
  }
}