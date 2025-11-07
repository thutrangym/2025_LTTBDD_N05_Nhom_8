import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventProvider extends ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {};

  Map<DateTime, List<Event>> get events => _events;

  List<Event> getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  void addEvent(Event event) {
    final normalizedDay = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
    );
    if (!_events.containsKey(normalizedDay)) {
      _events[normalizedDay] = [];
    }
    _events[normalizedDay]!.add(event);
    notifyListeners();
  }

  void removeEvent(Event event) {
    final normalizedDay = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
    );
    _events[normalizedDay]?.removeWhere((e) => e.id == event.id);
    if (_events[normalizedDay]?.isEmpty ?? false) {
      _events.remove(normalizedDay);
    }
    notifyListeners();
  }

  void updateEvent(Event oldEvent, Event newEvent) {
    removeEvent(oldEvent);
    addEvent(newEvent);
  }
}
