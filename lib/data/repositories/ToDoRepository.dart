import 'package:to_do_app/data/model/ToDoElement.dart';

class ToDoRepository {
  ToDoRepository({
    required ToDoElement toDo
  }) : _toDo = toDo;
  final ToDoElement _toDo;

  void onChecked() {
      _toDo.checked = _toDo.checked;
  }
}