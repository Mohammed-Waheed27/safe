import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Service locator instance
final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  final dio = Dio();
  getIt.registerLazySingleton(() => dio);

  // Feature: Auth
  _initAuthDependencies();

  // TODO: Add dependencies for other features as they are implemented
}

/// Initialize auth feature dependencies
void _initAuthDependencies() {
  // Bloc
  getIt.registerFactory(() => AuthBloc(loginUser: getIt(), registerUser: getIt()));

  // Use cases
  getIt.registerLazySingleton(() => LoginUser(getIt()));
  getIt.registerLazySingleton(() => RegisterUser(getIt()));

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      // Add local data source when needed
    ),
  );

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );
}

// Note: This file only defines the dependency structure.
// The actual implementation files for the repositories, data sources,
// use cases, and blocs will be created separately in their respective
// feature folders.
