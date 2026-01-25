import 'dart:convert';
import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/status.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';
import 'catalogues_datasource.dart';
import '../models/service.dart';

/// Datasource que lee catálogos desde archivos JSON locales (assets).
class CataloguesLocalDatasource implements CataloguesDatasource {
   final Dio dio;
  CataloguesLocalDatasource(this.dio);
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
  Future<List<Staff>> getStaff() {
    return _load(
      'assets/data/owner/catalogues/staff_mock.json',
      (json) => Staff.fromJson(json),
    );
  }
 @override
  Future<List<CatalogueItem>> getAppointmentStatuses() async {
    final res = await dio.get('/test1');
    final data = res.data['data'] as List<dynamic>;
    return data
        .map((e) => CatalogueItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  Future<List<Status>> getStatuses() {
    return _load(
      'assets/data/owner/catalogues/statuses_mock.json',
      (json) => Status.fromJson(json),
    );
  }
}
