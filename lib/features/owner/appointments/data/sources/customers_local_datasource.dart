import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/customer.dart';
import 'customers_datasource.dart';

/// Implementación local usando JSON mock
class CustomersLocalDatasource implements CustomersDatasource {
  static const _assetPath = 'assets/data/owner/catalogues/customers_mock.json';
  List<Customer>? _cache;

  Future<List<Customer>> _getAll() async {
    if (_cache != null) return _cache!;

    final jsonString = await rootBundle.loadString(_assetPath);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> data = jsonMap['data'] as List<dynamic>;

    _cache = data
        .map((item) => Customer.fromJson(item as Map<String, dynamic>))
        .toList();

    return _cache!;
  }

  @override
  Future<Customer?> getByTaxIdentification(String cedula) async {
    final customers = await _getAll();
    try {
      return customers.firstWhere(
        (c) => c.taxIdentification == cedula,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Customer>> searchCustomers(String query) async {
    final customers = await _getAll();
    final lower = query.toLowerCase();

    return customers.where((c) {
      final name = c.fullName?.toLowerCase() ?? '';
      final email = c.email?.toLowerCase() ?? '';
      final phone = c.phone?.toLowerCase() ?? '';
      final ci = c.taxIdentification?.toLowerCase() ?? '';
      return name.contains(lower) ||
          email.contains(lower) ||
          phone.contains(lower) ||
          ci.contains(lower);
    }).toList();
  }
}
