import 'package:flutter/material.dart';
import 'package:to_do_app/data/model/to_do_model.dart';
import 'package:to_do_app/ui/core/ui/error_indicator.dart';
import 'package:to_do_app/ui/home/view_models/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.deleteToDo.addListener(_onResult);
    widget.viewModel.renameToDo.addListener(_onResult);
    widget.viewModel.addToDo.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.deleteToDo.removeListener(_onResult);
    oldWidget.viewModel.renameToDo.removeListener(_onResult);
    oldWidget.viewModel.addToDo.removeListener(_onResult);
    widget.viewModel.deleteToDo.addListener(_onResult);
    widget.viewModel.renameToDo.addListener(_onResult);
    widget.viewModel.addToDo.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.deleteToDo.removeListener(_onResult);
    widget.viewModel.renameToDo.removeListener(_onResult);
    widget.viewModel.addToDo.removeListener(_onResult);
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
  return Scaffold(
       body: SafeArea(
        top: true,
        bottom: true,
        child: ListenableBuilder(
          listenable: widget.viewModel.load,
          builder: (context, child) {
            if (widget.viewModel.load.running) {
              return const Center(child: CircularProgressIndicator());
            }

            if (widget.viewModel.load.error) {
              return ErrorIndicator(
                title: "Error loading home screen",
                label: "Try again",
                onPressed: widget.viewModel.load.execute,
              );
            }

            return child!;
          },
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return ListView.builder(
                itemCount: widget.viewModel.toDoList.length,
                itemBuilder: (_, index) => _ToDoElement(
                  key: ValueKey(widget.viewModel.getToDobyIndex(index).id),
                  toDo: widget.viewModel.getToDobyIndex(index), 
                  onCheck: () async {
                    final id = widget.viewModel.getToDobyIndex(index).id;
                    if (id == null) return;
                    widget.viewModel.checkToDo.execute(id);
                  },
                  confirmDismiss: (_) async {
                    final id = widget.viewModel.getToDobyIndex(index).id;
                    if (id == null) return false;
                    await widget.viewModel.deleteToDo.execute(id);
                    if (widget.viewModel.deleteToDo.completed) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  changeName: () async {
                    final id = widget.viewModel.getToDobyIndex(index).id;
                    if (id == null) return;
                    widget.viewModel.renameToDo.execute(id);
                  }
                )
              );
            }
          ),
    )
    ),
     floatingActionButton: FloatingActionButton(
        onPressed: () => widget.viewModel.addToDo.execute(),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
  );
  }

    void _onResult() {
    if (widget.viewModel.deleteToDo.completed) {
      widget.viewModel.deleteToDo.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ToDo deleted")),
      );
    }

    if (widget.viewModel.deleteToDo.error) {
      widget.viewModel.deleteToDo.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error when trying to delete ToDo"),
        ),
      );
    }

    if (widget.viewModel.renameToDo.completed) {
      widget.viewModel.renameToDo.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ToDo renamed"),
        ),
      );
    }

    if (widget.viewModel.renameToDo.error) {
      widget.viewModel.renameToDo.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error when renaming ToDo"),
        ),
      );
    }

    if (widget.viewModel.addToDo.completed) {
      widget.viewModel.addToDo.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("ToDo added"),
        ),
      );
    }

    if (widget.viewModel.addToDo.error) {
      widget.viewModel.addToDo.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error when adding ToDo"),
        ),
      );
    }

  }
}

class _ToDoElement extends StatefulWidget {
  const _ToDoElement({
    super.key,
    required this.toDo,
    required this.onCheck,
    required this.confirmDismiss,
    required this.changeName,
  });

  final ToDo toDo;
  final GestureTapCallback onCheck;
  final ConfirmDismissCallback confirmDismiss;
  final VoidCallback changeName;

  @override
  State<_ToDoElement> createState() => _ToDoElementState();
}

class _ToDoElementState extends State<_ToDoElement> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.toDo.name);
  }

  @override
  void didUpdateWidget(covariant _ToDoElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jeśli ToDo zmienił się (inna instancja) — aktualizuj controller
    if (oldWidget.toDo.id != widget.toDo.id) {
      _controller.text = widget.toDo.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.toDo.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: widget.confirmDismiss,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
       ),
      child: Row(
      children: [
        Checkbox(
          value: widget.toDo.checked,
          onChanged: (bool? value) {
              widget.onCheck();
            }
          ),
          const SizedBox(width: 10,),
          Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => widget.changeName()
              ),
            ),
      ],
    )
    );
  }
}

