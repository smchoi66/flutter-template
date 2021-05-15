import 'package:flutter/material.dart';
import 'package:flutter_basic/controllers/todo_controller.dart';
import 'package:flutter_basic/screens/widgets/todo_form.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: GetBuilder<TodoController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: todoController.todos.length,
            itemBuilder: (_, int index) {
              return ListTile(
                onTap: () {
                  showBottomSheet(
                    context: context,
                    builder: (context) {
                      return TodoForm(
                        type: 'update',
                        todo: todoController.todos[index],
                      );
                    },
                  );
                },
                title: Text(todoController.todos[index].description),
                leading: Checkbox(
                  value: todoController.todos[index].isCompleted,
                  onChanged: (value) =>
                      todoController.changeStatus(todoController.todos[index]),
                ),
                trailing: IconButton(
                  onPressed: () =>
                      todoController.deleteTodo(todoController.todos[index]),
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return const TodoForm(
                type: "new",
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
