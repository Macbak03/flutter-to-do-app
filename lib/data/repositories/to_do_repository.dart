import 'package:to_do_app/data/services/database_service.dart';
import 'package:to_do_app/domain/models/to_do/to_do_model.dart';
import 'package:to_do_app/utils/result.dart';

class ToDoRepository{
  ToDoRepository({
    required DatabaseService database,
  }) : _database = database;

  final DatabaseService _database;
  final _toDoList = List<ToDo>.empty(growable: true);

  Future<Result<void>> addToDo() async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return await _database.insert();
  }

  Future<Result<void>> removeToDo(int id) async {
    final toDo = _toDoList.where((element) => element.id == id).firstOrNull;
    if (toDo == null) {
      return Result.error(Exception("Error when trying to delete ToDo: ToDo not found"));
    }
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.delete(id);
  }

  Future<Result<void>> checkToDo(int id) async {
    var toDo = _toDoList.where((element) => element.id == id).firstOrNull;
    if (toDo == null) {
      return Result.error(Exception("toDo not found when trying to check"));
    }
    toDo.checked = !toDo.checked;
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.updateChecked(id, toDo.checked);
  }

  Future<Result<void>> renameToDo(int id, String task) async {
    var toDo = _toDoList.where((element) => element.id == id).firstOrNull;
    if (toDo == null) {
      return Result.error(Exception("toDo not found when trying to check"));
    }
    toDo.task = task;
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.updateTask(id, task);
  } 

  Future<Result<List<ToDo>>> getToDoList() async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    final result = await _database.getAll();
    switch (result) {
      case Ok<List<ToDo>>():
        _toDoList.clear();
        _toDoList.addAll(result.value);
      case Error<List<ToDo>>():
        return Result.error(result.error);       
    }
    return result;
  }
}