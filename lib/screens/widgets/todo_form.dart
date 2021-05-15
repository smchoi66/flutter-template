import 'package:flutter/material.dart';
import 'package:flutter_basic/controllers/todo_controller.dart';
import 'package:flutter_basic/models/todo.dart';
import 'package:get/get.dart';

class TodoForm extends StatefulWidget {
  final String? type;
  final Todo? todo;

  const TodoForm({Key? key, this.type, this.todo}) : super(key: key);
  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  late String description;

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: widget.todo != null ? widget.todo!.description : '',
              onSaved: (newValue) => description = newValue!,
              decoration: const InputDecoration(hintText: 'Add Description'),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                _formKey.currentState!.save();
                if (widget.type == 'new') {
                  todoController.addTodo(Todo(description: description));
                } else {
                  todoController.updateTodo(widget.todo!, description);
                }
                Get.back();
              },
              child: Text(
                widget.todo != null ? 'Update' : 'Add',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
