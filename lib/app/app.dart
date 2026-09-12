import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/get_auth_state.dart';
import '../features/auth/domain/usecases/login_user.dart';
import '../features/auth/domain/usecases/logout_user.dart';
import '../features/auth/domain/usecases/register_user.dart';
import '../features/auth/domain/usecases/reset_password.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/tasks/data/datasources/task_local_datasource.dart';
import '../features/tasks/data/datasources/task_remote_datasource.dart';
import '../features/tasks/data/repositories/task_repository_impl.dart';
import '../features/tasks/domain/usecases/create_task.dart';
import '../features/tasks/domain/usecases/delete_task.dart';
import '../features/tasks/domain/usecases/get_tasks.dart';
import '../features/tasks/domain/usecases/toggle_task.dart';
import '../features/tasks/domain/usecases/update_task.dart';
import '../features/tasks/presentation/bloc/task_bloc.dart';

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Composition Root - Wire data sources, repositories, and use cases
    final authRemoteDataSource = AuthRemoteDataSourceImpl();
    final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);

    final taskRemoteDataSource = TaskRemoteDataSourceImpl();
    final taskLocalDataSource = TaskLocalDataSourceImpl();
    final taskRepository = TaskRepositoryImpl(
      remoteDataSource: taskRemoteDataSource,
      localDataSource: taskLocalDataSource,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            loginUser: LoginUser(authRepository),
            registerUser: RegisterUser(authRepository),
            logoutUser: LogoutUser(authRepository),
            getAuthState: GetAuthState(authRepository),
            resetPassword: ResetPassword(authRepository),
          ),
        ),
        BlocProvider<TaskBloc>(
          create: (_) => TaskBloc(
            getTasks: GetTasks(taskRepository),
            createTask: CreateTask(taskRepository),
            updateTask: UpdateTask(taskRepository),
            deleteTask: DeleteTask(taskRepository),
            toggleTask: ToggleTask(taskRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
      ),
    );
  }
}
