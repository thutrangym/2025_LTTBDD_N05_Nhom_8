import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/models/routine.dart';
import 'package:my_first_flutter_app/models/user_model.dart';
import 'package:my_first_flutter_app/screens/calendar/calendar_screen.dart';
import 'package:my_first_flutter_app/screens/home/home_screen.dart';
import 'package:my_first_flutter_app/screens/pomodoro/pomodoro_screen.dart';
import 'package:my_first_flutter_app/screens/settings/setting_screen.dart';
import 'package:my_first_flutter_app/screens/stats/stats_screen.dart';
import 'package:my_first_flutter_app/services/database_service.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({
    super.key,
    required this.user,
    required this.databaseService,
  });

  final UserModel user;
  final DatabaseService databaseService;

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(user: widget.user),
      RoutineTab(
        databaseService: widget.databaseService,
        userId: widget.user.uid,
      ),
      const CalendarScreen(),
      const PomodoroScreen(),
      const StatsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.repeat), label: 'Routine'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Pomodoro'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class RoutineTab extends StatelessWidget {
  const RoutineTab({
    super.key,
    required this.databaseService,
    required this.userId,
  });

  final DatabaseService databaseService;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RoutineTask>>(
      stream: databaseService.getRoutines(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final routines = snapshot.data ?? const <RoutineTask>[];

        return Scaffold(
          appBar: AppBar(title: const Text('Routine')),
          body: routines.isEmpty
              ? const Center(child: Text('No routines found.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: routines.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final routine = routines[index];
                    return ListTile(
                      leading: Icon(
                        routine.isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                      ),
                      title: Text(routine.name),
                      subtitle: Text(routine.time),
                    );
                  },
                ),
        );
      },
    );
  }
}
