import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:to_do_app/data/model/to_do_model.dart';
import 'package:to_do_app/data/repositories/to_do_repository.dart';
import 'package:to_do_app/utils/command.dart';
import 'package:to_do_app/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required ToDoRepository toDoListRepository
}) : _toDoListRepository = toDoListRepository {
  load = Command0(_load)..execute();
  addToDo = Command0(_addToDo);
  deleteToDo = Command1(_deleteToDo);
  renameToDo = Command1(_renameToDo);
  checkToDo = Command1(_checkToDo);
}

  final ToDoRepository _toDoListRepository;

  final _log = Logger();

  List<ToDo> toDoList = [];

  late Command0 load;
  late Command0 addToDo;
  late Command1<void, int> deleteToDo;
  late Command1<void, int> renameToDo;
  late Command1<void, int> checkToDo;

  Future<Result> _load() async {
    try {
      final result = await _toDoListRepository.getToDoList();
      switch (result) {
        case Ok<List<ToDo>>():
          toDoList = result.value;
          _log.i("Loaded ToDo list");
        case Error<List<ToDo>>():
          _log.e("Failed to load ToDo list", error: result.error);       
      }
      sleep(Duration(seconds: 2)); //for now sleep to test loading indicator
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _addToDo() async {
    try {
      final resultAdd = await _toDoListRepository.addToDo();
      switch (resultAdd) {
      case Ok<void>():
        _log.i('Added ToDo');
      case Error<void>():
        _log.e('Failed to add ToDo', error: resultAdd.error);
      return resultAdd;
      }

      final resultFetch = await _toDoListRepository.getToDoList();
      switch (resultFetch) {
        case Ok<List<ToDo>>():
          toDoList = resultFetch.value;
        case Error<List<ToDo>>():
          _log.e("Failed to load ToDo list", error: resultFetch.error);       
      }
      return resultFetch;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteToDo(int id) async {
      try {
        final resultDelete = await _toDoListRepository.removeToDo(id);
        switch (resultDelete) {
        case Ok<void>():
          _log.i('Deleted ToDo $id');
        case Error<void>():
          _log.e('Failed to delete ToDO $id', error: resultDelete.error);
        return resultDelete;
        }

        //Reload to do list from database (in the future)
        sleep(Duration(seconds: 2));
        return Result.ok(null);
      } finally {
        notifyListeners();
      }
  }

  Future<Result<void>> _renameToDo(int id) async {
    try {
      final toDo = toDoList.where((element) => element.id == id).firstOrNull;
      if (toDo == null) {
        return Result.error(Exception("ToDo was null"));
      }
      final resultRename = await _toDoListRepository.renameToDo(id, toDo.name);
      switch (resultRename) {
        case Ok<void>():
        _log.i('Renamed ToDo $id');
      case Error<void>():
        _log.e('Failed to rename ToDo $id', error: resultRename.error);
      }
      //Reload to do list from database
      sleep(Duration(seconds: 2));
      return resultRename;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _checkToDo(int id) async {
    try {
      final resultCheck = await _toDoListRepository.checkToDo(id);
      switch (resultCheck) {
        case Ok<void>():
          _log.i('ToDo $id checked');
        case Error<void>():
        _log.e('Failed to check ToDo $id', error: resultCheck.error);
      }
      return resultCheck;
    } finally {
      notifyListeners();
    }
  }

  ToDo getToDobyIndex(int index) {
    return toDoList[index];
  }
}