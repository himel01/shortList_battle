import 'package:battle_app/models/model_album.dart';
import 'package:battle_app/models/model_photo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final _dbName = "myDatabase.db";
  final _dbVersion = 1;

  final _tableAlbum = "Album";
  final columnAlbum = '_fetched_album';

  final _tablePhoto = "Photo";
  final columnPhoto = '_fetched_photo';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database ??= await _initiateDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initiateDatabase() async {
    String directory = await getDatabasesPath();
    String path = join(directory, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        print("creating");
        await db.execute('''
      CREATE TABLE $_tableAlbum (
      $columnAlbum TEXT
      )
      ''');
        await db.execute('''
      CREATE TABLE $_tablePhoto (
      $columnPhoto TEXT
      )
      ''');
      },
    );
  }

  Future<int?> insertAlbum(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(_tableAlbum, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int?> insertPhoto(ModelPhoto list) async {
    Database? db = await instance.database;
    return await db?.insert(_tablePhoto, list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAlbum() async {
    Database? db = await instance.database;
    return await db!.query(_tableAlbum);
  }

  Future<List<Map<String, dynamic>>> queryPhoto() async {
    Database? db = await instance.database;
    return await db!.query(_tableAlbum);
  }

  Future<List<ModelAlbum>> retrieveAlbum() async {
    final Database? db = await database;
    final List<Map> maps = await db!.query(_tableAlbum);
    return List.generate(maps.length, (i) {
      return ModelAlbum(
        id: maps[i]['id'],
        title: maps[i]['title'],
        userId: maps[i]['userId'],
      );
    });
  }

  Future<List<ModelPhoto>> retrievePhoto() async {
    final Database? db = await database;
    final List<Map> maps = await db!.query(_tablePhoto);
    return List.generate(maps.length, (i) {
      return ModelPhoto(
        albumId: maps[i]['albumId'],
        thumbnailUrl: maps[i]['thumbnailUrl'],
        url: maps[i]['url'],
        id: maps[i]['id'],
        title: maps[i]['title'],
      );
    });
  }
}
