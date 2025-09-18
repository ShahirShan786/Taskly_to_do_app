import 'package:taskly_to_do_app/core/data/models/todo_model.dart';

abstract class TaskRepository {
  Future<TodoModel> createTask(TodoModel task);
  Stream<List<TodoModel>> getAllTask();
  Future<void> deleteTask(String taskId);
}