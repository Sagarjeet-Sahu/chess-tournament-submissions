import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_helper.dart';
import '../models/match.dart';

final matchProvider =
    StateNotifierProvider<MatchNotifier, List<MatchModel>>((ref) {
  return MatchNotifier();
});

class MatchNotifier extends StateNotifier<List<MatchModel>> {
  MatchNotifier() : super([]);

  Future<void> loadMatches(int tournamentId) async {
    state = await DatabaseHelper.instance.getMatches(tournamentId);
  }

  Future<void> addMatch(MatchModel match) async {
    await DatabaseHelper.instance.insertMatch(match);
    await loadMatches(match.tournamentId);
  }
}