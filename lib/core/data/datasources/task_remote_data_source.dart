import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskly_to_do_app/core/data/models/todo_model.dart';

abstract class TaskRemoteDataSource {
  Future<TodoModel> createTask(TodoModel task);
  Stream<List<TodoModel>> getAllTask();
  Future<void> deleteTask(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<TodoModel> createTask(TodoModel task) async {
    try {
       final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      final docref = firestore.collection('Users')
                              .doc(user.uid)
                              .collection('todos')
                              .doc();

      final newTask = TodoModel(
          id: docref.id,
          title: task.title,
          description: task.description,
          dueDate: task.dueDate,
          dueTime: task.dueTime,
          priority: task.priority,
          username: user.displayName
          );
          
          await docref.set(newTask.toMap());

          return newTask;
    } catch (e) {
      throw Exception("Failed to create task :$e");
    }
  }
  
  @override
  Stream<List<TodoModel>> getAllTask() {
     final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User not logged in");
  }

  return firestore
      .collection('Users')
      .doc(user.uid)
      .collection('todos')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => TodoModel.fromMap(doc.data(), doc.id))
        .toList();
  });
  }
  
  @override
  Future<void> deleteTask(String taskId) async{
   try{
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) throw Exception("User not logged in");

    final docRef = firestore
                   .collection('Users')
                   .doc(user.uid)
                   .collection('todos')
                   .doc(taskId);

                  final snapshot = await docRef.get();
                  if(!snapshot.exists){
                    throw Exception("Task not found (id :$taskId)");
                  }

                  await docRef.delete();
   }catch(e){
    throw Exception("Failed to delete task :$e");
   }
  }
}
