import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'data/local/hive_manager.dart';
import 'services/notification_service.dart';
import 'services/pomodoro_service.dart';
import 'data/local/local_storage_service.dart';
import 'data/repositories/todo_repository.dart';
import 'data/repositories/goal_repository.dart';
import 'data/repositories/routine_repository.dart';
import 'providers/app_state.dart';
import 'providers/todo_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/routine_provider.dart';
import 'providers/pomodoro_provider.dart';
import 'providers/stats_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  // Initialize Hive
  await HiveManager.init();

  // Initialize Notifications
  await NotificationService.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/i18n',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final pomodoroService = PomodoroService();

    // Initialize repositories
    final localStorage = LocalStorageService();

    final todoRepository = TodoRepository(localStorage: localStorage);

    final goalRepository = GoalRepository(localStorage: localStorage);

    final routineRepository = RoutineRepository(localStorage: localStorage);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(
          create: (_) => PomodoroProvider(service: pomodoroService),
        ),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
        ChangeNotifierProvider(
          create: (_) => TodoProvider(repository: todoRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalProvider(repository: goalRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => RoutineProvider(repository: routineRepository),
        ),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Self Management',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
            darkTheme: ThemeData(
              primarySwatch: Colors.indigo,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            themeMode: appState.themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const App(userId: 'demo-user'),
          );
        },
      ),
    );
  }
}
