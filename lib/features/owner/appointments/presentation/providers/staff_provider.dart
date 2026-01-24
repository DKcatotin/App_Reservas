import 'dart:convert';
import 'package:agenda_app/core/logger/app_logger.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



/// Provider que carga la lista de staff desde assets/data/owner/staff.json
final staffListProvider = FutureProvider<List<Staff>>((ref) async {
  try {
    final jsonString = await rootBundle.loadString('assets/data/owner/catalogues/staff_mock.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Staff.fromJson(json)).toList();
  } catch (e) {
    AppLogger.d('Error cargando staff: $e');
    return []; // Retorna lista vacía si hay error
  }
});
