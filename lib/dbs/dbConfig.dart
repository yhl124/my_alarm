import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'my_alarms.dart';

class DataBaseService {
  static final DataBaseService _database = DataBaseService._internal();
  static Database? _db;
  //late Future<Database> database;
  factory DataBaseService() => _database;

  DataBaseService._internal() {
    //databaseConfig();
  }

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await databaseConfig();
    return _db!;
  }

  Future<Database> databaseConfig() async {
    return openDatabase(
      join(await getDatabasesPath(), 'alarm_db.db'),
      onCreate:(db, version) {
        return db.execute(
          'CREATE TABLE alarms(id INTEGER PRIMARY KEY, alarmName TEXT, alarmTime TEXT, usingAlarmSound INTEGER)'
        );
      },
      version: 1,
    );
  }


  /*
  Future<bool> databaseConfig() async {
    try{
      database = openDatabase(
        join(await getDatabasesPath(), 'alarm_db.db'),
        onCreate:(db, version) {
          return db.execute(
            'CREATE TABLE alarms(id INTEGER PRIMARY KEY, alarmName TEXT, alarmTime TEXT, usingAlarmSound INTEGER)'
          );
        },
        version: 1,
      );
      return true;
    }
    catch (err) {
      print(err.toString());
      return false;
    }
  }
  */

  Future<bool> insertAlarm(MyAlarm myalram) async {
    final Database db = await database;
    try{
      db.insert(
        'alarms', //위에서 작성한 테이블 이름
        myalram.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    }
    catch (err) {
      return false;
    }
  }

  Future<List<MyAlarm>> selectAlarms() async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('alarms');

    return List.generate(data.length, (i) {
      return MyAlarm(
        id: data[i]['id'], 
        alarmName: data[i]['alarmName'], 
        alarmTime: data[i]['alarmTime'], 
        usingAlarmSound: data[i]['usingAlarmSound']
      );
    });
  }

  Future<MyAlarm> selectAlarm(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('alarms', where: "id = ?", whereArgs: [id]);

    return MyAlarm(
      id: data[0]['id'], 
      alarmName: data[0]['alarmName'], 
      alarmTime: data[0]['alarmTime'], 
      usingAlarmSound: data[0]['usingAlarmSound']
    );
  }

  Future<bool> updateAlarm(MyAlarm myalarm) async {
    final Database db = await database;
    try{
      db.update(
        'alarms',
        myalarm.toMap(),
        where: "id = ?",
        whereArgs: [myalarm.id],
      );
      return true;
    }
    catch (err) {
      return false;
    }
  }

  Future<bool> deleteAlarm(int id) async {
    final Database db = await database;
    try{
      db.delete(
        'alarms',
        where: "id = ?",
        whereArgs: [id],
      );
      return true;
    }
    catch (err) {
      return false;
    }
  }
}