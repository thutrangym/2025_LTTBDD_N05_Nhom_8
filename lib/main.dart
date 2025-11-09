import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/providers/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'data/local/hive_manager.dart';
import 'services/notification_service.dart';
import 'services/pomodoro_service.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'screens/app_wrapper.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  // Initialize Hive
  await HiveManager.init();

  final savedLanguageCode = HiveManager.settingsBox.get('language') as String?;
  final startLocale = savedLanguageCode == 'vi'
      ? const Locale('vi')
      : const Locale('en');

  // Initialize Notifications
  await NotificationService.initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/i18n',
      fallbackLocale: const Locale('en'),
      startLocale: startLocale,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key})
    : _authService = AuthService(),
      _databaseService = DatabaseService();

  final AuthService _authService;
  final DatabaseService _databaseService;

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
        ChangeNotifierProvider(create: (_) => StatsProvider()),
        ChangeNotifierProvider(
          create: (_) => GoalProvider(repository: goalRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => TodoProvider(repository: todoRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => RoutineProvider(repository: routineRepository),
        ),
        ChangeNotifierProxyProvider2<
          StatsProvider,
          GoalProvider,
          PomodoroProvider
        >(
          create: (_) => PomodoroProvider(service: pomodoroService),
          update: (_, stats, goals, pomodoro) {
            pomodoro!.attachDependencies(stats, goals);
            return pomodoro;
          },
        ),
        ChangeNotifierProvider(create: (_) => EventProvider()),
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
            home: AppWrapper(
              authService: _authService,
              databaseService: _databaseService,
            ),
          );
        },
      ),
    );
  }
}
