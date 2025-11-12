import 'package:to_do_app/data/model/ToDoElement.dart';
import 'package:to_do_app/utils/result.dart';

class ToDoListRepository{
  final _toDoList = List<ToDoElement>.empty(growable: true);
  int _sequentialId = 0;

  Future<Result<void>> addToDo(ToDoElement toDo) async {
    toDo.id = _sequentialId ++;
    _toDoList.add(toDo);
    return const Result.ok(null);
  }

  Future<Result<void>> removeToDo(ToDoElement toDo) async {
      if (_toDoList.contains(toDo)) {
        _toDoList.remove(toDo);
      } else {
        return Result.error(Exception("toDo not found"));
      }

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
}