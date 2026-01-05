import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/appointment.dart';
import 'appointments_datasource.dart';

class AppointmentsJsonDatasource implements AppointmentsDatasource {
  Future<List<Appointment>> _load(String path) async {
    final raw = await rootBundle.loadString(path);
    final decoded = jsonDecode(raw) as Map;
    final list = decoded['data'];
    if (list is! List) return [];
    return list
        .map((e) => Appointment.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<List<Appointment>> getAll() async {
    final today = await _load('assets/data/owner/appointments/appointments_today.json');
    final past = await _load('assets/data/owner/appointments/appointments_past.json');
    final upcoming = await _load('assets/data/owner/appointments/appointments_upcoming.json');

    final all = [...past, ...today, ...upcoming];
    all.sort((a, b) => a.startAt.compareTo(b.startAt));
    return all;
  }

  @override
  Future<void> create(Appointment appointment) {
    throw UnimplementedError('AppointmentsJsonDatasource is read-only');
  }
}

