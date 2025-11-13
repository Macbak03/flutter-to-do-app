import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:to_do_app/data/repositories/to_do_repository.dart';

/// Configure dependencies

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (context) => 
        ToDoRepository() 
    ),
  ];
}