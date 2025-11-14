import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_app/domain/models/to_do/to_do_model.dart';
import 'package:to_do_app/utils/result.dart';


class DatabaseService extends Sqflite{
  DatabaseService({
    required DatabaseFactory databaseFactory,
  }) : _databaseFactory = databaseFactory;
  static const String _todoTableName = 'todo';
  static const String _idColumnName = '_id';
  static const String _taskColumnName = 'task';
  static const String _taskChecked = 'taskChecked';

  Database? _database;
  final DatabaseFactory _databaseFactory;

  Future<void> open() async { 
    _database = await _databaseFactory.openDatabase(
      join(await _databaseFactory.getDatabasesPath(), 'app_database.db'),
      options: OpenDatabaseOptions(
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE $_todoTableName('
            '$_idColumnName INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$_taskColumnName TEXT DEFAULT \'\', '
            '$_taskChecked INTEGER DEFAULT 0 CHECK($_taskChecked IN (0, 1))'
            ')',
          );
        },
        version: 1,
      ),
    );
  }

  Future<Result<void>> insert() async {
    try {
      await _database!.insert(_todoTableName, {
        _taskColumnName: '',
        _taskChecked: 0,  
      });
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<ToDo>>> getAll() async {
    try {
      final entries = await _database!.query(
        _todoTableName,
        columns: [_idColumnName, _taskColumnName, _taskChecked],
      );
      final list = entries
          .map(
            (element) => ToDo(
              id: element[_idColumnName] as int,
              task: element[_taskColumnName] as String,
              checked: (element[_taskChecked] as int) == 1,
            ),
          )
          .toList();
      return Result.ok(list);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      final rowsDeleted = await _database!.delete(
        _todoTableName,
        where: '$_idColumnName = ?',
        whereArgs: [id],
      );
      if (rowsDeleted == 0) {
        return Result.error(Exception('No todo found with id $id'));
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> updateTask(int id, String task) async {
    try {
      final rowsUpdated = await _database!.update(
        _todoTableName,
        {_taskColumnName: task},
        where: '$_idColumnName = ?',
        whereArgs: [id],
      );
      if (rowsUpdated == 0) {
        return Result.error(Exception('No todo found with id $id'));
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> updateChecked(int id, bool checked) async {
    try {
      final rowsUpdated = await _database!.update(
        _todoTableName,
        {_taskChecked: checked ? 1 : 0},
        where: '$_idColumnName = ?',
        whereArgs: [id],
      );
      if (rowsUpdated == 0) {
        return Result.error(Exception('No todo found with id $id'));
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  bool isOpen() {
    return _database != null;
  }
}