import 'package:flutter/material.dart';

enum EventType {
  study(Icons.school, Colors.blue),
  work(Icons.work, Colors.orange),
  personal(Icons.person, Colors.green),
  health(Icons.favorite, Colors.red),
  social(Icons.people, Colors.purple),
  other(Icons.event, Colors.grey);

  final IconData icon;
  final Color color;

  const EventType(this.icon, this.color);
}

class Event {
  final String id;
  final String name;
  final DateTime date;
  final TimeOfDay time;
  final EventType type;
  final String details;

  Event({
    String? id,
    required this.name,
    required this.date,
    required this.time,
    required this.type,
    required this.details,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Event copyWith({
    String? name,
    DateTime? date,
    TimeOfDay? time,
    EventType? type,
    String? details,
  }) {
    return Event(
      id: id,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      type: type ?? this.type,
      details: details ?? this.details,
    );
  }
}
