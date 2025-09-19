
import 'package:taskly_to_do_app/core/data/datasources/task_remote_data_source.dart';
import 'package:taskly_to_do_app/core/data/models/todo_model.dart';
import 'package:taskly_to_do_app/core/domain/repositories/task_repository.dart';

class TaskRepositoryImpl  implements TaskRepository{

 final TaskRemoteDataSource taskRemoteDataSource;

  TaskRepositoryImpl(this.taskRemoteDataSource);
 
  
  @override
  Future<TodoModel> createTask(TodoModel task) {
    return taskRemoteDataSource.createTask(task);
  }
  
  @override
  Stream<List<TodoModel>> getAllTask() {
    return taskRemoteDataSource.getAllTask();


  }
  
  @override
  Future<void> deleteTask(String taskId) {
    return taskRemoteDataSource.deleteTask(taskId);
  }
  
  @override
  Future<void> updateTask(TodoModel task, String taskId) {
    return taskRemoteDataSource.updateTask(task, taskId);
  }

  
}