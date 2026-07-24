import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/player.dart';
import '../models/tournament.dart';
import '../models/match.dart';

class DatabaseHelper{
  static final DatabaseHelper instance=DatabaseHelper._();

  DatabaseHelper._();

  Database? _database;

  Future<Database> get database async{
    if(_database!=null) return _database!;

    _database=await initDB();
    return _database!;
  }

  Future<Database> initDB() async{
    String path=join(await getDatabasesPath(),"chess.db");

    return await openDatabase(
      path,
      version:4,
      onCreate: (db,version) async{
        await db.execute("""
        CREATE TABLE players(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        rating INTEGER)
        """);

        await db.execute("""
        CREATE TABLE tournaments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        location TEXT,
        date TEXT)
        """);

        await db.execute("""
        CREATE TABLE tournament_players(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tournamentId INTEGER,
        playerId INTEGER)
       """);

        await db.execute("""
        CREATE TABLE matches(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tournamentId INTEGER,
        player1 INTEGER,
        player2 INTEGER,
        winner INTEGER,
        round INTEGER)
        """);
      },

      onUpgrade: (db,oldVersion,newVersion) async {
        if(oldVersion<2){
          await db.execute("""
      CREATE TABLE tournaments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        location TEXT,
        date TEXT) """ 
        );
        }

        if(oldVersion<3){
            await db.execute("""
        CREATE TABLE tournament_players(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tournamentId INTEGER,
        playerId INTEGER)"""
        );
        }

        if (oldVersion < 4) {
        await db.execute("""
        CREATE TABLE matches(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tournamentId INTEGER,
        player1 INTEGER,
        player2 INTEGER,
        winner INTEGER,
        round INTEGER)
        """);
      }

      }
    );
  }

  Future<void> insertPlayer(Player player) async{
    final db=await database;
    await db.insert("players",player.toMap());
  }

  Future<List<Player>> getPlayers() async {
    final db=await database;
    final result=await db.query("players");
    return result.map((e) => Player.fromMap(e)).toList();
  }

  Future<void> updatePlayer(Player player) async{
    final db=await database;

    await db.update(
      "players",
      player.toMap(),
      where:"id=?",
      whereArgs: [player.id], 
    );
  }

  Future<void> deletePlayer(int id) async{
    final db = await database;
    
    await db.delete(
      "players",
      where: "id=?",
      whereArgs:[id],
    );
  }

  Future<void> insertTournament(Tournament tournament) async {
  final db = await database;

  await db.insert(
    "tournaments",
    tournament.toMap(),
  );
}

Future<List<Tournament>> getTournaments() async {
  final db = await database;

  final result = await db.query("tournaments");

  return result.map((e) => Tournament.fromMap(e)).toList();
}

Future<void> updateTournament(Tournament tournament) async {
  final db = await database;

  await db.update(
    "tournaments",
    tournament.toMap(),
    where: "id=?",
    whereArgs: [tournament.id],
  );
}

Future<void> deleteTournament(int id) async {
  final db = await database;

  await db.delete(
    "tournaments",
    where: "id=?",
    whereArgs: [id],
  );
}

Future<void> addPlayerToTournament(int tournamentId,int playerId, ) async {
  final db = await database;
  await db.insert(
    "tournament_players",
    {
      "tournamentId": tournamentId,
      "playerId": playerId,
    },
  );
} 

Future<List<Player>> getTournamentPlayers(int tournamentId,) async {

  final db = await database;

  final result = await db.rawQuery("""
SELECT players.*
FROM players
INNER JOIN tournament_players
ON players.id=tournament_players.playerId
WHERE tournament_players.tournamentId=?
""", [tournamentId]);
  return result.map((e) => Player.fromMap(e)).toList();
}

  Future<void> insertMatch(MatchModel match) async {
  final db = await database;

  await db.insert(
    "matches",
    match.toMap(),
  );
}

   Future<List<MatchModel>> getMatches(int tournamentId) async {
  final db = await database;

  final result = await db.query(
    "matches",
    where: "tournamentId=?",
    whereArgs: [tournamentId],
  );

  return result
      .map((e) => MatchModel.fromMap(e))
      .toList();
}

   Future<void> deleteMatches(int tournamentId) async {
   final db = await database;

    await db.delete(
    "matches",
    where: "tournamentId=?",
    whereArgs: [tournamentId],
  );
}
}