import '../models/customer.dart';

/// Interface para obtener customers (local o remoto)
abstract class CustomersDatasource {
  Future<Customer?> getByTaxIdentification(String cedula);
  Future<List<Customer>> searchCustomers(String query);
}

