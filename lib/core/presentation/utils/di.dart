// import 'package:taskly_to_do_app/core/data/datasources/remote_data_source.dart';
// import 'package:taskly_to_do_app/core/data/repositories/user_repository_impl.dart';
// import 'package:taskly_to_do_app/core/domain/repositories/user_repository.dart';
// import 'package:taskly_to_do_app/core/domain/usecases/authentication.dart';
// import 'package:get_it/get_it.dart';

// void setupDependencies() {
//   // Register the UserRepository and RemoteDataSource with GetIt
//   GetIt.instance.registerLazySingleton<UserRepository>(
//       () => UserRepositoryImpl(RemoteDataSource()));

//   // Register the AuthenticateUserUseCase with GetIt, initializing it with UserRepository
//   GetIt.instance.registerLazySingleton<AuthenticationUseCase>(
//       () => AuthenticationUseCase(GetIt.instance<UserRepository>()));
// }
