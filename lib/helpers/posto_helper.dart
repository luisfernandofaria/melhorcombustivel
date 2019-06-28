import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:melhor_combustivel/model/posto.dart';

class PostoHelper {

  static final PostoHelper _instance = PostoHelper.internal();

  PostoHelper.internal();

  factory PostoHelper() => _instance;

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    final path = await getDatabasesPath();
    final pathDB = join(path, "posto.db");


    final String sql = "CREATE TABLE posto ("
        "c_id INTEGER PRIMARY KEY,"
        "c_nome TEXT,"
        "c_valorAlcool TEXT,"
        "c_valorGasolina TEXT,"
        "c_resultado TEXT,"
        "c_data TEXT"
        ")";

    return await openDatabase(
        pathDB,
        version: 1,
        onCreate: (Database DB, int newerVersion) async {
          await DB.execute(sql);
        });
  }

  Future<Posto> insert(Posto posto) async {
    Database dbPosto = await db;
    posto.id = await dbPosto.insert("posto", posto.toMap());
    return posto;
  }

  Future<Posto> selectById(int id) async {
    Database dbPosto = await db;
    List<Map> maps = await dbPosto.query(
        "posto",
        columns: [
          "c_id", "c_nome", "c_valorAlcool", "c_valorGasolina",
        "c_resultado", "c_data"],
        where: "c_id = ?",
        whereArgs: [id]
    );
    if (maps.length > 0){
      return Posto.fromMap(maps.first);
    } else {
      return null;
    }

  }

  Future<List> selectAll() async {
    Database dbPosto = await db;
    List list = await dbPosto.rawQuery("SELECT * FROM posto");
    List<Posto> listPosto = List();
    for (Map m in list) {
      listPosto.add(Posto.fromMap(m));
    }
    return listPosto;
  }

  Future<int> update(Posto posto) async {
    Database dbPosto = await db;
    return await dbPosto.update("posto",
        posto.toMap(),
        where: "c_id = ?",
        whereArgs: [posto.id]);
  }

  Future<int> delete(Posto posto) async {
    Database dbPosto = await db;
    return await dbPosto.delete("posto", where: "c_id = ?", whereArgs: [posto.id]);
  }

  Future close() async {
    Database dbPosto = await db;
    dbPosto.close();
  }
}
