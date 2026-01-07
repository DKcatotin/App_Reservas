import 'dart:convert';
import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff_full.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'catalogues_datasource.dart';
import '../models/service.dart';

/// Datasource que lee catálogos desde archivos JSON locales (assets).
class CataloguesLocalDatasource implements CataloguesDatasource {
  Future<List<T>> _load<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final raw = await rootBundle.loadString(path);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['data'] as List?;

    if (list == null) return [];

    return list
        .map((e) => fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<List<Service>> getServices() {
    return _load(
      'assets/data/owner/catalogues/services_mock.json',
      (json) => Service.fromJson(json),
    );
  }

  @override
  Future<List<StaffFull>> getStaff() {
    return _load(
      'assets/data/owner/catalogues/staff_mockjson',
      (json) => StaffFull.fromJson(json),
    );
  }
 @override
  Future<List<CatalogueItem>> getAppointmentStatuses() {
    return _load(
      'assets/data/owner/catalogues/statuses_mock.json',
      CatalogueItem.fromJson,
    );
  }
}
