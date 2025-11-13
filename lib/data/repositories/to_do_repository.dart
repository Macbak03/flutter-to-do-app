import 'package:to_do_app/data/model/to_do_model.dart';
import 'package:to_do_app/utils/result.dart';

class ToDoRepository{
  final _toDoList = List<ToDo>.empty(growable: true);
  int _sequentialId = 0;

  Future<Result<void>> addToDo() async {
    ToDo toDo = ToDo(id: _sequentialId++);
    _toDoList.add(toDo);
    return const Result.ok(null);
  }

  Future<Result<void>> removeToDo(int id) async {
    final toDo = _toDoList.where((element) => element.id == id).firstOrNull;
    if (toDo == null) {
      return Result.error(Exception("Error when trying to delete ToDo: ToDo not found"));
    }
    _toDoList.remove(toDo);

    return const Result.ok(null);
  }

  Future<Result<void>> checkToDo(int id) async {
    var toDo = _toDoList.where((element) => element.id == id).firstOrNull;
    if (toDo == null) {
      return Result.error(Exception("toDo not found when trying to check"));
    }
    toDo.checked = toDo.checked;
    _toDoList.where((element) => element.id == toDo.id).firstOrNull?.checked = toDo.checked;  

    return const Result.ok(null);
  }

  Future<Result<void>> renameToDo(int id, String name) async {
    var toDo = _toDoList.where((element) => element.id == id).firstOrNull;
    if (toDo == null) {
      return Result.error(Exception("toDo not found when trying to check"));
    }
    toDo.name = name;
    _toDoList.where((element) => element.id == toDo.id).firstOrNull?.name = toDo.name;  

    return const Result.ok(null);
  } 

  Future<Result<List<ToDo>>> getToDoList() async {
    return Result.ok(_toDoList);
  }
}