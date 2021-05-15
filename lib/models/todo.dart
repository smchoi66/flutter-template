import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String description;
  @HiveField(2)
  bool isCompleted;
  Todo({
    this.description = '',
    this.isCompleted = false,
  }) : id = const Uuid().v1();
}
