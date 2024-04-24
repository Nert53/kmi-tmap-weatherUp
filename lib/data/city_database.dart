import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather/model/city.dart';
import 'package:shortuid/shortuid.dart';

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
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE $tableCity ( 
        ${CityFields.id} $idType, 
        ${CityFields.name} $textType,
        ${CityFields.country} $textType,
        ${CityFields.latitude} $doubleType,
        ${CityFields.longitude} $doubleType
        )
      ''');

    addCity(City(
        id: ShortUid.create(),
        name: 'London',
        country: 'UK',
        latitude: 51.5074,
        longitude: 0.1278));
    addCity(City(
        id: ShortUid.create(),
        name: 'Paris',
        country: 'France',
        latitude: 48.8566,
        longitude: 2.3522));
    addCity(City(
        id: ShortUid.create(),
        name: 'Berlin',
        country: 'Germany',
        latitude: 52.5200,
        longitude: 13.4050));
  }

  Future close() async {
    final db = await instance.db;
    db.close();
  }

  Future<bool> addCity(City city) async {
    final db = await instance.db;

    final id = await db.insert(tableCity, city.toJson());
    if (id != 0) {
      return true;
    }
    return false;
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
