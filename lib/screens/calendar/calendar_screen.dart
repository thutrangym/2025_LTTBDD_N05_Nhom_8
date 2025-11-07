import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../../models/event_model.dart';
import '../../providers/event_provider.dart';
import '../../core/widgets/custom_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDetailsController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  EventType _selectedEventType = EventType.other;

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('calendar'.tr())),
      body: Column(
        children: [
          const SizedBox(height: 8),
          CustomCard(
            margin: const EdgeInsets.all(16),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: (day) {
                return context.read<EventProvider>().getEventsForDay(day);
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Events for ${_formatDate(_selectedDay)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Consumer<EventProvider>(
                  builder: (context, eventProvider, _) {
                    final events = eventProvider.getEventsForDay(_selectedDay);
                    if (events.isEmpty) {
                      return Text(
                        'No events for this day',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      );
                    }
                    return Column(
                      children: events
                          .map((event) => EventCard(event: event))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddEventDialog(BuildContext context) {
    _eventNameController.clear();
    _eventDetailsController.clear();
    _selectedTime = TimeOfDay.now();
    _selectedEventType = EventType.other;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'add_calendar'.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _eventNameController,
                  decoration: InputDecoration(
                    labelText: 'Event Name'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${_formatDate(_selectedDay)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) {
                          setState(() => _selectedTime = time);
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text(_selectedTime.format(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<EventType>(
                  value: _selectedEventType,
                  decoration: const InputDecoration(
                    labelText: 'Event Type',
                    border: OutlineInputBorder(),
                  ),
                  items: EventType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(type.icon, color: type.color),
                          const SizedBox(width: 8),
                          Text(type.name.toUpperCase()),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (EventType? value) {
                    if (value != null) {
                      setState(() => _selectedEventType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _eventDetailsController,
                  decoration: InputDecoration(
                    labelText: 'Event Details'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('cancel'.tr()),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        if (_eventNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter an event name'),
                            ),
                          );
                          return;
                        }

                        final event = Event(
                          name: _eventNameController.text,
                          date: _selectedDay,
                          time: _selectedTime,
                          type: _selectedEventType,
                          details: _eventDetailsController.text,
                        );

                        context.read<EventProvider>().addEvent(event);

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Event created')),
                        );
                      },
                      child: Text('save'.tr()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================
// Separate EventCard Widget
// =============================

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: event.type.color.withOpacity(0.2),
          child: Icon(event.type.icon, color: event.type.color),
        ),
        title: Text(event.name),
        subtitle: Text(
          '${event.time.format(context)} - ${event.details}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            context.read<EventProvider>().removeEvent(event);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Event deleted')));
          },
        ),
      ),
    );
  }
}
