import 'package:taskly_to_do_app/core/data/models/todo_model.dart';
import 'package:taskly_to_do_app/core/domain/repositories/task_repository.dart';

class TaskUsecases {
  final TaskRepository taskRepository;

  TaskUsecases(this.taskRepository);
  
  Future<TodoModel> call(TodoModel task){
    return taskRepository.createTask(task);
  }

  Stream<List<TodoModel>> getAllTask(){
    return taskRepository.getAllTask();
  }

  Future<void> deleteTask(String taskId){
    return taskRepository.deleteTask(taskId);
  }
}