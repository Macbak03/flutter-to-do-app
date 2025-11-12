import 'package:flutter/material.dart';
import 'package:to_do_app/data/model/ToDoElement.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var toDoList = <ToDoElement>[];

  void _addToDo(String name) {
    setState(() {
      var toDo = ToDoElement(name: name);
      toDoList.add(toDo);
    });
  }

  void _removeToDo(ToDoElement toDo) {
    setState(() {
      if (toDoList.contains(toDo)) {
        toDoList.remove(toDo);
      }
    });
  }

  Future<void> _nameToDo() async {
    String toDoName = "";
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('What to do?'),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (value) => toDoName = value,
              ),
            ),
            TextButton(
              onPressed: () {
                _addToDo(toDoName);
                Navigator.of(context).pop();
              }, 
              child: Text("add")
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: 
            ListView(
              children: [
                for (var toDo in toDoList)
                  Dismissible(
                    key: Key(toDo.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        _removeToDo(toDo);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${toDo.name} removed')),
                      );
                    },
                    child: ToDo(toDo: toDo),
                  )
              ],

            )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nameToDo,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



class ToDo extends StatefulWidget {
  const ToDo({
    super.key,
    required this.toDo,
  });

  final ToDoElement toDo;

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.toDo.checked,
          onChanged: (bool? value) {
            setState(() {
              if (value != null) {
              widget.toDo.checked = value;
              }
            });
          }
          ),
          const SizedBox(width: 10,),
          Text(widget.toDo.name),
      ],
    );
  }
}
