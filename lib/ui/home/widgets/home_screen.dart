import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    // TODO: implement build
    throw UnimplementedError();
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



