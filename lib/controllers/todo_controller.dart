import 'package:flutter_basic/models/todo.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class TodoController extends GetxController {
  late List<Todo> _todos;
  late Box<Todo> todoBox;

  List<Todo> get todos => _todos;

  TodoController() {
    todoBox = Hive.box('todos');
    _todos = [];

    for (final todo in todoBox.values) {
      _todos.add(todo);
      update();
    }
  }

  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    await todoBox.add(todo);
    update();
  }

  void deleteTodo(Todo todo) {
    final int index = _todos.indexOf(todo);
    todoBox.deleteAt(index);
    _todos.removeWhere((element) => element.id == todo.id);

    update();
  }

  void changeStatus(Todo todo) {
    final int index = _todos.indexOf(todo);

    _todos[index].isCompleted = !_todos[index].isCompleted;
    _todos[index].save();
    todoBox.putAt(index, _todos[index]);
    update();
  }

  void updateTodo(Todo oldTodo, String newDescription) {
    final int index = _todos.indexOf(oldTodo);
    _todos[index].description = newDescription;
    _todos[index].save();
    todoBox.putAt(index, _todos[index]);
    update();
  }
}
