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
  // Cargar en paralelo en lugar de secuencial
  final results = await Future.wait([
    _load('assets/data/owner/appointments/appointments_today.json'),
    _load('assets/data/owner/appointments/appointments_past.json'),
    _load('assets/data/owner/appointments/appointments_upcoming.json'),
  ]);
  
  final all = [...results[0], ...results[1], ...results[2]];
  
  // Eliminar duplicados
  final uniqueMap = <String, Appointment>{};
  for (var appointment in all) {
    uniqueMap[appointment.id] = appointment;
  }
  
  final uniqueAppointments = uniqueMap.values.toList();
  uniqueAppointments.sort((a, b) => a.startAt.compareTo(b.startAt));
  
  return uniqueAppointments;
}

  @override
  Future<void> create(Appointment appointment) {
    throw UnimplementedError('AppointmentsJsonDatasource is read-only');
  }

  @override
  Future<void> update(Appointment appointment) {
    throw UnimplementedError('AppointmentsJsonDatasource is read-only');
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError('AppointmentsJsonDatasource is read-only');
  }
}
