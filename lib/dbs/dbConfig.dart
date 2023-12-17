import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'my_alarms.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'alarm_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE alarms(notiId INTEGER PRIMARY KEY AUTOINCREMENT, '
          'alarmId TEXT NOT NULL, useDate INTEGER NOT NULL, '
          'alarmDate TEXT NOT NULL, alarmTime TEXT NOT NULL, alarmName TEXT, '
          'useHoliday INTEGER NOT NULL, holidayOp INTEGER, '
          'useSound INTEGER NOT NULL, soundName TEXT, useVibe INT NOT NULL, vibeOp STRING, '
          'useRepeat INTEGER NOT NULL, repeatOp INTEGER)'
        );
      },
      version: 8,
      onUpgrade: _onUpgrade
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if(oldVersion < newVersion) {
      await db.execute("DROP TABLE IF EXISTS alarms");
      await db.execute('CREATE TABLE alarms(notiId INTEGER PRIMARY KEY AUTOINCREMENT, '
                        'alarmId TEXT NOT NULL, useDate INTEGER NOT NULL, '
                        'alarmDate TEXT NOT NULL, alarmTime TEXT NOT NULL, alarmName TEXT, '
                        'useHoliday INTEGER NOT NULL, holidayOp INTEGER, '
                        'useSound INTEGER NOT NULL, soundName TEXT, useVibe INT NOT NULL, vibeOp STRING, '
                        'useRepeat INTEGER NOT NULL, repeatOp INTEGER)');
    }
  }

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
/*
  Future<bool> updateAlarm(MyAlarm myalram) async {
    final Database db = await database;
    try{
      db.update(
        'alarms', //위에서 작성한 테이블 이름
        myalram.toMap(),
        where: 'id = ?',
        whereArgs: [myalram.notiId],
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return true;
    }
    catch (err) {
      return false;
    }
  }
*/

  Future<List<MyAlarm>> selectAlarms() async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('alarms');

    return List.generate(data.length, (i) {
      return MyAlarm(
        notiId: data[i]['notiId'],
        alarmId: data[i]['alarmId'],
        useDate: data[i]['useDate'],
        alarmDate: data[i]['alarmDate'], 
        alarmTime: data[i]['alarmTime'],
        alarmName: data[i]['alarmName'],
        useHoliday: data[i]['useHoliday'],
        holidayOp: data[i]['holidayOp'],
        useSound: data[i]['useSound'],
        soundName: data[i]['soundName'],
        useVibe: data[i]['useVibe'],
        vibeOp: data[i]['vibeOp'],
        useRepeat: data[i]['useRepeat'],
        repeatOp: data[i]['repeatOp']
      );
    });
  }

    //alarm_block에 사용할 select
    Future<List<Map<String, dynamic>>> selectblockAlarms(String alarmId) async {
      final Database db = await database;
      final List<Map<String, dynamic>> data = await db.query('alarms', where: "alarmId = ?", whereArgs: [alarmId]);

      return List.generate(data.length, (i) {
        return {
          'notiId': data[i]['notiId'],
          'alarmId': data[i]['alarmId'],
          'useDate': data[i]['useDate'],
          'alarmDate': data[i]['alarmDate'], 
          'alarmTime': data[i]['alarmTime'],
          'alarmName': data[i]['alarmName']
        };
      });
    }

    //main에서 사용할 select
    Future<List<Map<String, dynamic>>> selectmainAlarms() async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('alarms' , groupBy: 'alarmId');

    return List.generate(data.length, (i) {
      return {
        'notiId': data[i]['notiId'],
        'alarmId': data[i]['alarmId'],
        'useDate': data[i]['useDate']
      };
    });
  }

  Future<MyAlarm> selectAlarm(String alarmid) async {
    final Database db = await database;
    final List<Map<String, dynamic>> data = await db.query('alarms', where: "alarmId = ?", whereArgs: [alarmid]);

    return MyAlarm(
      notiId: data[0]['notiId'],
      alarmId: data[0]['alarmId'],
      useDate: data[0]['useDate'],
      alarmDate: data[0]['alarmDate'], 
      alarmTime: data[0]['alarmTime'],
      alarmName: data[0]['alarmName'],
      useHoliday: data[0]['useHoliday'],
      holidayOp: data[0]['holidayOp'],
      useSound: data[0]['useSound'],
      soundName: data[0]['soundName'],
      useVibe: data[0]['useVibe'],
      vibeOp: data[0]['vibeOp'],
      useRepeat: data[0]['useRepeat'],
      repeatOp: data[0]['repeatOp']
    );
  }

  Future<bool> deleteAlarm(String alarmid) async {
    final Database db = await database;
    try{
      db.delete(
        'alarms',
        where: "alarmId = ?",
        whereArgs: [alarmid],
      );
      return true;
    }
    catch (err) {
      return false;
    }
  }
}














/*
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
*/