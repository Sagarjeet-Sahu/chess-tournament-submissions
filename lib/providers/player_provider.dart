import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../models/player.dart';

final playerProvider=
     StateNotifierProvider<PlayerNotifier,List<Player>>((ref){
      return PlayerNotifier();
     });

class PlayerNotifier extends StateNotifier<List<Player>>{
  PlayerNotifier(): super([]){
    loadPlayers();
  }


Future<void> loadPlayers() async{
  state= await DatabaseHelper.instance.getPlayers();
}

Future<void> addPlayer(Player player) async {
  await DatabaseHelper.instance.insertPlayer(player);
  loadPlayers();
}

Future<void> updatePlayer(Player player) async{
  await DatabaseHelper.instance.updatePlayer(player);
  await loadPlayers();
}

Future<void> deletePlayer(int id) async {
  await DatabaseHelper.instance.deletePlayer(id);
  await loadPlayers();
  }
}