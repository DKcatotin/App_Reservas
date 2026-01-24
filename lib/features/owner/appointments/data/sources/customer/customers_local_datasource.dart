import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../models/customer.dart';
import 'customers_datasource.dart';

/// Implementación local usando JSON mock
class CustomersLocalDatasource implements CustomersDatasource {
  static const _assetPath = 'assets/data/owner/catalogues/customers_mock.json';
  List<Customer>? _cache;

  @override
  Future<List<Customer>> getAll() async {
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
  Future<Customer?> getByTaxIdentification(String taxIdentification) async {
    final customers = await getAll();
    try {
      return customers.firstWhere((c) => c.taxIdentification == taxIdentification);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Customer?> getById(String id) async {
    final customers = await getAll();
    try {
      return customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
/*
  @override
  Future<Customer> create(Customer customer) async {
    final customers = await getAll();
    customers.add(customer);
    _cache = customers;
    return customer;
  }

  @override
  Future<Customer> update(Customer customer) async {
    final customers = await getAll();
    final index = customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      customers[index] = customer;
      _cache = customers;
    }
    return customer;
  }

  @override
  Future<void> delete(String id) async {
    final customers = await getAll();
    customers.removeWhere((c) => c.id == id);
    _cache = customers;
  }
  */
}
