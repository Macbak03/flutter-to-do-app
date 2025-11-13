import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/config/dependencies.dart';
import 'package:to_do_app/routing/router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: providers,
      child:  const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router(),
    );
  }
}