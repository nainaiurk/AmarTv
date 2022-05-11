import 'package:live_tv/model/model_user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final _dbName = "myDatabase.db";
  final _dbVersion = 1;
  final _tableName = "User";



  final columnUserId = '_id';
  final columnName = '_name';
  final columnEmail = '_email';
  final columnImage = '_image';



  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database ??= await _initiateDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  _initiateDatabase() async {
    String directory = await getDatabasesPath();
    String path = join(directory, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) {
    return db.execute('''
      CREATE TABLE $_tableName (
      $columnUserId TEXT,
      $columnName TEXT NOT NULL,
      $columnEmail TEXT PRIMARY KEY,
      $columnImage TEXT
      )
      
       ''');

  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  // Future<List<Favorite>> retrieveFavorite() async {
  //   final Database db = await database;
  //   final List<Map> maps = await db.query(_tableName);
  //   return List.generate(maps.length, (i) {
  //     return Favorite(
  //       channelId: maps[i][columnChannelId],
  //       channelName: maps[i][columnChannelName],
  //       channelCategory: maps[i][columnChannelCategory],
  //       channelImage: maps[i][columnChannelImage],
  //       channelType: maps[i][columnChannelType],
  //       channelUrl: maps[i][columnChannelUrl],
  //     );
  //   });
  // }

  Future<List<User>> retrieveUser() async {
    final Database db = await database;
    final List<Map> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return User(
          id: maps[i][columnUserId],
          name: maps[i][columnName],
          email: maps[i][columnEmail],
          image: maps[i][columnImage],
          );
    });
  }
  Future<void> deleteUser(String mail) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      _tableName,
      // Use a `where` clause to delete a specific dog.
      where: '_email = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [mail],
    );
  }


}