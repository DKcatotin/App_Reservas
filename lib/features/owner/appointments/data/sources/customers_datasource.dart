import 'dart:convert';

import 'package:agenda_app/features/owner/appointments/data/models/customer.dart';
import 'package:flutter/services.dart' show rootBundle;

class CustomersDatasource {
  static const _assetPath =
      'assets/data/owner/catalogues/customers_mock.json';

  List<Customer>? _cache;

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

  Future<Customer?> getByTaxIdentification(String taxIdentification) async {
  final customers = await getAll();
  try {
    return customers.firstWhere((c) => c.taxIdentification == taxIdentification);
  } catch (_) {
    return null;
  }
}

  Future<void> add(Customer customer) async {
    final customers = await getAll();
    customers.add(customer);
  }
}


