import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/data/local/local_storage_service.dart';
import 'package:my_first_flutter_app/data/repositories/goal_repository.dart';
import 'package:my_first_flutter_app/data/repositories/routine_repository.dart';
import 'package:my_first_flutter_app/data/repositories/todo_repository.dart';
import 'package:my_first_flutter_app/providers/goal_provider.dart';
import 'package:my_first_flutter_app/screens/routine/routine_screen.dart';
import 'package:my_first_flutter_app/services/database_service.dart';
import 'package:my_first_flutter_app/services/pomodoro_service.dart';
import 'package:provider/provider.dart';

import 'models/user_model.dart';
import 'providers/app_state.dart';
import 'providers/event_provider.dart';
import 'providers/pomodoro_provider.dart';
import 'providers/todo_provider.dart';
import 'providers/routine_provider.dart';

import 'screens/calendar/calendar_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/pomodoro/pomodoro_screen.dart';
import 'screens/settings/setting_screen.dart';
import 'screens/stats/stats_screen.dart';

class App extends StatefulWidget {
  const App({super.key, required this.userId});

  final String userId;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await fetchUserFromDatabase(widget.userId);
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localStorage = LocalStorageService();
    final todoRepository = TodoRepository(localStorage: localStorage);
    final goalRepository = GoalRepository(localStorage: localStorage);
    final routineRepository = RoutineRepository(localStorage: localStorage);
    final pomodoroService = PomodoroService();

    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screens = <Widget>[
      HomeScreen(user: _user!),
      const RoutineScreen(),
      const CalendarScreen(),
      const PomodoroScreen(),
      const StatsScreen(),
      const SettingsScreen(),
    ];

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(
          create: (_) => PomodoroProvider(service: pomodoroService),
        ),
        ChangeNotifierProvider(
          create: (_) => TodoProvider(repository: todoRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => RoutineProvider(repository: routineRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalProvider(repository: goalRepository),
        ),
        Provider(create: (_) => DatabaseService()),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Self Management',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: appState.themeMode,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: Scaffold(
              body: screens[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTabSelected,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.indigo,
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    label: 'Routine',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: 'Calendar',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.timer),
                    label: 'Pomodoro',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart),
                    label: 'Stats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<UserModel?> fetchUserFromDatabase(String userId) async {
  // TODO: Replace with your actual user fetch logic
  await Future.delayed(const Duration(milliseconds: 250));
  return UserModel(uid: userId, displayName: 'Guest');
}
