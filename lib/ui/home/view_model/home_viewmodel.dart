import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:to_do_app/data/repositories/to_do_repository.dart';
import 'package:to_do_app/utils/command.dart';
import 'package:to_do_app/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required ToDoRepository toDoListRepository
}) : _toDoListRepository = toDoListRepository {
  load = Command0(_load)..execute();
  deleteToDo = Command1(_deleteToDo);
  renameToDo = Command2(_renameToDo);
}

  final ToDoRepository _toDoListRepository;

  final _log = Logger();

  late Command0 load;
  late Command1<void, int> deleteToDo;
  late Command2<void, int, String> renameToDo;

  Future<Result<void>> _load() async {
    sleep(Duration(seconds: 2)); //for now sleep to test loading indicator

    return const Result.ok(null);
  }

  Future<Result<void>> _deleteToDo(int id) async {
      try {
        final resultDelete = await _toDoListRepository.removeToDo(id);
        switch (resultDelete) {
          case Ok<void>():
          _log.i('Deleted booking $id');
        case Error<void>():
          _log.e('Failed to delete booking $id', error: resultDelete.error);
          return resultDelete;
        }

        //Reload to do list from database (in the future)
        sleep(Duration(seconds: 2));
        return Result.ok(null);
      } finally {
        notifyListeners();
      }
  }

  Future<Result<void>> _renameToDo(int id, String name) async {
    try {
      final resultRename = await _toDoListRepository.renameToDo(id, name);
      switch (resultRename) {
        case Ok<void>():
        _log.i('Renamed ToDo $id to $name');
      case Error<void>():
        _log.e('Failed to rename ToDo $id', error: resultRename.error);
        return resultRename;
      }
      //Reload to do list from database
      sleep(Duration(seconds: 2));
      return Result.ok(null);
    } finally {
      notifyListeners();
    }
  }
}