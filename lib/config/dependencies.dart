import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:to_do_app/data/repositories/to_do_repository.dart';
import 'package:to_do_app/data/services/database_service.dart';

/// Configure dependencies

List<SingleChildWidget> get providers {
  return [
    Provider<DatabaseService>(
      create: (context) {
        if (kIsWeb) {
          throw UnsupportedError('Platform not supported');
        } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
          // Initialize FFI SQLite
          sqfliteFfiInit();
          return DatabaseService(databaseFactory: databaseFactoryFfi);
        } else {
          // Use default native SQLite
          return DatabaseService(databaseFactory: databaseFactory);
        }
      }
    ),
    Provider<ToDoRepository>(
      create: (context) => 
        ToDoRepository(
          database: context.read<DatabaseService>(),
        ),
    ),
  ];
}