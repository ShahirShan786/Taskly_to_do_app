import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_to_do_app/core/data/models/todo_model.dart';
import 'package:taskly_to_do_app/core/domain/usecases/task_usecases.dart';

class TaskNotifiers  extends StateNotifier<AsyncValue<List<TodoModel>>>{
  final TaskUsecases taskUsecases;

  TaskNotifiers(this.taskUsecases) : super(const AsyncValue.loading()){
    _init();
  }

    void _init() {
   
    listenToTasks();
  }


  // create task
  Future<void> addTask(TodoModel task) async{
    try{
    await taskUsecases.call(task);
     
    }catch(e , st){
      state = AsyncValue.error(e, st);
    }
  }


  void listenToTasks(){
    taskUsecases.getAllTask().listen((tasks){
      state = AsyncValue.data(tasks);
    }, onError: (e , st){
      state = AsyncValue.error(e, st);
    });
  }

  Future<void> updateTask(TodoModel task , String taskId)async{
    
    try{
      await taskUsecases.updateTask(task, taskId);
    }catch(e ,st){
      state = AsyncValue.error(e, st);
    } 
    
     }

  Future<void> deleteTask(String taskId)async{
    try{
      await taskUsecases.deleteTask(taskId);
    }catch(e , st){
      state = AsyncValue.error(e, st);
    }
  }


}