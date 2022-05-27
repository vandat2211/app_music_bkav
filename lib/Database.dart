import 'package:app_music_bkav/Model/music_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
}