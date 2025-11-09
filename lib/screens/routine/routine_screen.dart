import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/models/routine.dart';
import 'package:my_first_flutter_app/services/database_service.dart';
import 'package:provider/provider.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  late DatabaseService _db;
  final _nameController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _db = Provider.of<DatabaseService>(context, listen: false);
    // Force initial load of routines
    _db.getRoutines().listen((event) {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _showAddRoutineDialog(RoutineType type) {
    _nameController.clear();
    _timeController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Routine ${type == RoutineType.morning ? "morning" : "evening"}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Routine'),
              ),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final time = _timeController.text.trim();
                if (name.isNotEmpty && time.isNotEmpty) {
                  await _db.addRoutine(name, time, type);
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoutineList(String title, RoutineType type) {
    print('Building routine list for $title');
    return StreamBuilder<List<RoutineTask>>(
      stream: _db.getRoutinesByType(type),
      builder: (context, snapshot) {
        print(
          'StreamBuilder update for $title - connection state: ${snapshot.connectionState}',
        );
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error in StreamBuilder for $title: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final routines = snapshot.data ?? [];
        print('$title routines count: ${routines.length}');

        return Card(
          margin: const EdgeInsets.all(12),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Colors.indigo,
                  onPressed: () => _showAddRoutineDialog(type),
                ),
              ],
            ),
            children: [
              if (routines.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No routines added yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ...routines.map((routine) {
                return ListTile(
                  leading: Checkbox(
                    value: routine.isCompleted,
                    onChanged: (val) {
                      _db.updateRoutineCompletion(routine.id, val ?? false);
                    },
                  ),
                  title: Text(routine.name),
                  subtitle: Text('Time: ${routine.time}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _db.deleteRoutine(routine.id),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _addMockData() async {
    print('Starting to add mock data...');
    try {
      // Morning routines
      final morningRoutines = [
        {'name': 'Make bed', 'time': '06:00 AM'},
        {'name': 'Drink water', 'time': '06:15 AM'},
        {'name': 'Exercise', 'time': '06:30 AM'},
        {'name': 'Personal hygiene', 'time': '07:00 AM'},
      ];

      // Evening routines
      final eveningRoutines = [
        {'name': 'Skin care', 'time': '08:00 PM'},
        {'name': 'Read', 'time': '08:30 PM'},
        {'name': 'Meditate', 'time': '09:00 PM'},
      ];

      print('Adding ${morningRoutines.length} morning routines...');
      // Add morning routines
      for (var routine in morningRoutines) {
        print('Adding morning routine: ${routine['name']}');
        await _db.addRoutine(
          routine['name']!,
          routine['time']!,
          RoutineType.morning,
        );
      }

      print('Adding ${eveningRoutines.length} evening routines...');
      // Add evening routines
      for (var routine in eveningRoutines) {
        print('Adding evening routine: ${routine['name']}');
        await _db.addRoutine(
          routine['name']!,
          routine['time']!,
          RoutineType.evening,
        );
      }

      // Trigger a reload of routines
      print('Triggering routine reload...');
      _db.getRoutines().listen((routines) {
        print('Reloaded routines, count: ${routines.length}');
      });
    } catch (e, stackTrace) {
      print('Error adding mock data: $e');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addMockData,
            tooltip: 'Add mock data',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildRoutineList('Morning', RoutineType.morning),
              _buildRoutineList('Evening', RoutineType.evening),
            ],
          ),
        ),
      ),
    );
  }
}
