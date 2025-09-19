import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly_to_do_app/core/data/datasources/task_remote_data_source.dart';
import 'package:taskly_to_do_app/core/data/models/todo_model.dart';
import 'package:taskly_to_do_app/core/data/repositories/task_repository_impl.dart';
import 'package:taskly_to_do_app/core/domain/repositories/task_repository.dart';
import 'package:taskly_to_do_app/core/domain/usecases/task_usecases.dart';
import 'package:taskly_to_do_app/core/presentation/notifiers/task_notifiers.dart';

// task provider
final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref){
  return TaskRemoteDataSourceImpl();
});

// task repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref){
  return TaskRepositoryImpl(ref.watch(taskRemoteDataSourceProvider));
});

// task usecase provider
final taskUsecaseProvider = Provider<TaskUsecases>((ref){
  return TaskUsecases(ref.watch(taskRepositoryProvider));
});

final taskNotifierProvider = StateNotifierProvider<TaskNotifiers , AsyncValue<List<TodoModel>>>((ref){
  return TaskNotifiers(ref.watch(taskUsecaseProvider));
});

