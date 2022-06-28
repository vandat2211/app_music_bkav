import 'dart:io';

import 'package:app_music_bkav/Model/music_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// class DatabaseProvider{
//   static final DatabaseProvider dbProvider=DatabaseProvider();
//   Database? database;
//   Future<Database> get db async{
//     if(database!=null){
//       return database!;
//     }else{
//       database=await createDatabase();
//       return database!;
//     }
//   }
//   Future<Database> createDatabase() async{
//     Directory docDirectory =await getApplicationDocumentsDirectory();
//     String path=join(docDirectory.path,"todo.db");
//     var database =await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db,int version) async{
//         await db.execute("""
//           CREATE TABLE MYTable(
//           id INTEGER PRIMERY KEY,
//           title TEXT,
//           artist TEXT,
//           path TEXT,
//           duration INTEGER,
//           artworkWidget BLOB
//           )
//           """);
//       },
//       onUpgrade: (Database db,int oldVersion,int newVersion){
//         if(newVersion > oldVersion){}
//       },
//     );
//     return database;
//   }
// }
class DB {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "MYDB.db"),
      onCreate: (database, verison) async {
        await database.execute("""
          CREATE TABLE MYTable(
          id INTEGER PRIMERY KEY,
          title TEXT,
          artist TEXT,
          path TEXT,
          duration INTEGER,
          isFavorite NUMERIC,
          artworkWidget BLOB
          )
          """);
      },
      version: 1,
    );
  }

  Future<bool> insertData(MusicModel songs) async {
    final Database db = await initDB();
    db.insert("MYTable", songs.toMap());
    return true;
  }
  Future<List<MusicModel>> getData()async{
    final Database db=await initDB();
    final List<Map<String,Object?>> datas=await db.query("MYTable");

    return datas.map((e) => MusicModel.fromMap(e)).toList();
  }
  Future<void> delete(int id)async{
    final Database db=await initDB();
    await db.delete("MYTable",where: "id=?",whereArgs: [id]);
  }
}