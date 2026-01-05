/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/appointment.dart';
import 'appointments_datasource.dart';

class AppointmentsMockApi implements AppointmentsDatasource {
  final List<Appointment> _memory = [];

  AppointmentsMockApi() {
    // Cargar inicial desde JSON UNA SOLA VEZ
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final today = await _load('assets/data/owner/appointments/appointments_today.json');
    final past = await _load('assets/data/owner/appointments/appointments_past.json');
    final upcoming = await _load('assets/data/owner/appointments/appointments_upcoming.json');

    _memory.addAll([...past, ...today, ...upcoming]);
  }

  Future<List<Appointment>> _load(String path) async {
    final raw = await rootBundle.loadString(path);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['data'] as List;
    return list.map((e) => Appointment.fromJson(e)).toList();
  }

  @override
  Future<void> create(Appointment appointment) async {
    _memory.add(appointment);
    debugPrint('CITAS GUARDADAS: ${_memory.length}');
  }

  @override
  Future<List<Appointment>> getToday() async {
    final today = DateTime.now();
    return _memory.where((a) =>
      _isSameDay(a.startAt, today),
    ).toList();
  }

  @override
  Future<List<Appointment>> getUpcoming() async {
    final today = DateTime.now();
    return _memory.where((a) =>
      a.startAt.isAfter(today),
    ).toList();
  }

  @override
  Future<List<Appointment>> getPast() async {
    final today = DateTime.now();
    return _memory.where((a) =>
      a.startAt.isBefore(today),
    ).toList();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
*/
