import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather/model/city.dart';

class CityDatabase {
  static final CityDatabase instance = CityDatabase._init();

  static Database? _db;

  CityDatabase._init();

  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await _initDB('city.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE $tableCity ( 
        ${CityFields.id} $idType, 
        ${CityFields.name} $textType,
        ${CityFields.country} $textType,
        ${CityFields.cityCode} $integerType,
        ${CityFields.latitude} $doubleType,
        ${CityFields.longitude} $doubleType
        )
      ''');
  }

  Future close() async {
    final db = await instance.db;
    db.close();
  }

  Future<City> addCity(City city) async {
    final db = await instance.db;

    final id = await db.insert(tableCity, city.toJson());
    return city.copy(id: id);
  }

  Future<City> getCity(int id) async {
    final db = await instance.db;

    final maps = await db.query(
      tableCity,
      columns: CityFields.values,
      where: '${CityFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return City.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<City>> getAllCities() async {
    final db = await instance.db;
    final result = await db.query(tableCity);
    return result.map((json) => City.fromJson(json)).toList();
  }

  Future<int> deleteCity(int id) async {
    final db = await instance.db;

    return await db.delete(
      tableCity,
      where: '${CityFields.id} = ?',
      whereArgs: [id],
    );
  }
}
