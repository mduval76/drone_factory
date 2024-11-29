import 'package:drone_factory/models/patch.dart';
import 'package:drone_factory/models/track.dart';
import 'package:drone_factory/utils/constants.dart';
import 'package:drone_factory/utils/name_generator.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

class DbHandler {
  static final DbHandler _instance = DbHandler._internal();
  Database? _database;
  static final NameGenerator _nameGenerator = NameGenerator();
  static const String dbName = 'df_database.db';

  factory DbHandler() {
    return _instance;
  }

  DbHandler._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, DbHandler.dbName),
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
        await _insertInitialData(db);
      },
    );
  }

  Future<void> closeDatabase() async {
    debugPrint('Closing database');
    final db = await database;
    await db.close();
  }

  Future<void> deleteDb() async {
    final dbPath = await getDatabasesPath();
    await deleteDatabase(join(dbPath, 'df_database.db'));
    _database = null;
  }

  Future<void> _createTables(Database db) async {
    debugPrint('Creating tables');
    await db.execute(
      '''
      PRAGMA foreign_keys = ON;
      '''
    );

    await db.execute(
      '''
      CREATE TABLE users (
        userId TEXT PRIMARY KEY
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE patches (
        patchId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        patchName TEXT NOT NULL,
        isSaved INTEGER NOT NULL DEFAULT 0,
        creationDate TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE
      )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE tracks (
        trackId INTEGER NOT NULL,
        patchId INTEGER NOT NULL,
        isMuted INTEGER NOT NULL DEFAULT 0,
        isSoloed INTEGER NOT NULL DEFAULT 0,
        isActive INTEGER NOT NULL DEFAULT 0,
        volume REAL NOT NULL DEFAULT 0.0,
        frequencyOffset REAL NOT NULL DEFAULT 440.0,
        wavetable INTEGER NOT NULL DEFAULT 4,
        PRIMARY KEY (trackId, patchId),
        FOREIGN KEY (patchId) REFERENCES patches(patchId) ON DELETE CASCADE
      )
      '''
    );
  }

  Future<void> _insertInitialData(Database db) async {
    debugPrint('Inserting initial data');
    await db.insert('users', {'userId': 'user1'});

    var random = Random();

    for (int i = 1; i <= 20; i++) {
      String patchName = _nameGenerator.generateDefaultName();
      String creationDate = DateTime.now().toIso8601String();

      Map<String, Object?> patchMap = {
        'userId': 'user1',
        'patchName': patchName,
        'creationDate': creationDate,
        'isSaved': 1,
      };

      int patchId = await db.insert('patches', patchMap);
      int activeTracksCount = 3 + random.nextInt(6);

      for (int trackNum = 0; trackNum < 8; trackNum++) {

        double minOffset = 20.0 - AudioConstants.defaultFrequency;
        double maxOffset = 1000.0 - AudioConstants.defaultFrequency;

        bool isActive = trackNum < activeTracksCount;

        Map<String, Object?> trackMap = {
          'trackId': trackNum,
          'patchId': patchId,
          'isMuted': 0,
          'isSoloed': 0,
          'isActive': isActive ? 1 : 0,
          'volume': isActive ? random.nextDouble() : 0.0,
          'frequencyOffset': isActive
              ? minOffset + random.nextDouble() * (maxOffset - minOffset)
              : 0.0,
          'wavetable': isActive
              ? random.nextInt(Wavetable.values.length - 1)
              : Wavetable.none.index,
        };

        await db.insert('tracks', trackMap);
      }
    }
  }

  /*
    CRUD OPERATIONS
  */

  // USERS ///////////////////////////////////////////////////////////
  Future<String> insertUser(String userId) async {
    try {
      final Database db = await database;

      final userExists = await db.query(
        'users',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      if (userExists.isEmpty) {
        await db.insert(
          'users',
          {'userId': userId},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        debugPrint('User was inserted successfully');
        return userId.toString();
      }
      else {
        debugPrint('User already exists');
        return userId.toString();
      }
    }
    catch (e) {
      debugPrint('Error inserting user: $e');
      return 'error';
    }
  }
  
  // TRACKS ///////////////////////////////////////////////////////////
  Future<List<Track>> getTracksByPatchId(int patchId) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> trackResults = await db.query(
        'tracks',
        where: 'patchId = ?',
        whereArgs: [patchId],
      );

      return List.generate(trackResults.length, (index) {
        return Track(
          trackId: trackResults[index]['trackId'],
          patchId: trackResults[index]['patchId'],
          isMuted: trackResults[index]['isMuted'] == 1,
          isSoloed: trackResults[index]['isSoloed'] == 1,
          isActive: trackResults[index]['isActive'] == 1,
          volume: trackResults[index]['volume'],
          frequencyOffset: trackResults[index]['frequencyOffset'],
          wavetable: Wavetable.values[trackResults[index]['wavetable']],
        );
      });
    }
    catch (e) {
      debugPrint('Error obtaining tracks by patchId: $e');
      return [];
    }
  }

  // PATCHES ///////////////////////////////////////////////////////////
  Future<int> insertPatch(Patch patch) async {
    try {
      final Database db = await database;
      final patchMap = patch.toMap();
      patchMap.remove('patchId');

      final int patchId = await db.insert(
        'patches',
        patchMap,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      for (final track in patch.tracks) {
        final trackMap = track.toMap();
        trackMap['patchId'] = patchId;
        await db.insert(
          'tracks',
          trackMap,
          conflictAlgorithm: ConflictAlgorithm.abort,
        );
      }
      return patchId;
    } 
    catch (e) {
      debugPrint('Error inserting patch: $e');
      return -1;
    }
  }

  Future<void> updatePatch(Patch patch) async {
    final Database db = await database;

    await db.update(
      'patches',
      patch.toMap(),
      where: 'patchId = ?',
      whereArgs: [patch.patchId],
    );

    await db.delete(
      'tracks',
      where: 'patchId = ?',
      whereArgs: [patch.patchId],
    );

    for (final track in patch.tracks) {
      await db.insert(
        'tracks',
        track.toMap()..addAll({'patchId': patch.patchId}),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    }
  }

  Future<void> deletePatch(int patchId) async {
    final Database db = await database;
    await db.delete(
      'patches',
      where: 'patchId = ?',
      whereArgs: [patchId],
    );
  }

  Future<List<Patch>> getPatchesByUserId(String userId) async {
    try {
      final Database db = await database;

      final userExists = await db.query(
        'users',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      if (userExists.isEmpty) {
        return [];
      }

      final List<Map<String, dynamic>> patchResults = await db.query(
        'patches',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      List<Patch> patches = [];
      for (final patchRow in patchResults) {
        final List<Track> tracks = await getTracksByPatchId(patchRow['patchId']);

        patches.add(Patch(
          patchId: patchRow['patchId'],
          userId: patchRow['userId'],
          patchName: patchRow['patchName'],
          tracks: tracks,
          isSaved: patchRow['isSaved'] == 1,
          creationDate: DateTime.parse(patchRow['creationDate']),
        ));
      }
      
      return patches;
    }
    catch (e) {
      debugPrint('Error obtaining patches by userId: $e');
      return [];
    }
  }
}