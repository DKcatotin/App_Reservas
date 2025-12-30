import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/appointment.dart';
import 'appointments_datasource.dart';

class AppointmentsJsonDatasource implements AppointmentsDatasource {
  Future<List<Appointment>> _load(String path) async {
    final raw = await rootBundle.loadString(path);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    final list = decoded['data'];
    if (list is! List) return [];

    return list
        .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Appointment>> getToday() {
    return _load(
      'assets/data/owner/appointments/appointments_today.json',
    );
  }

  @override
  Future<List<Appointment>> getPast() {
    return _load(
      'assets/data/owner/appointments/appointments_past.json',
    );
  }

  @override
  Future<List<Appointment>> getUpcoming() {
    return _load(
      'assets/data/owner/appointments/appointments_upcoming.json',
    );
  }

  @override
  Future<void> create(Appointment appointment) {
    throw UnimplementedError(
      'AppointmentsJsonDatasource is read-only',
    );
  }
}
