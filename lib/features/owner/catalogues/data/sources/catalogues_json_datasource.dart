import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../appointments/data/models/customer.dart';
import '../models/service.dart';
import '../models/staff_full.dart';

class CataloguesJsonDatasource {
  Future<List<Customer>> getCustomers() async {
    final raw = await rootBundle.loadString('assets/data/owner/catalogues/customers_mock.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['data'] as List;
    return list.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<StaffFull>> getStaff() async {
    final raw = await rootBundle.loadString('assets/data/owner/catalogues/staff_mock.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['data'] as List;
    return list.map((e) => StaffFull.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Service>> getServices() async {
    final raw = await rootBundle.loadString('assets/data/owner/catalogues/services_mock.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['data'] as List;
    return list.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList();
  }
}