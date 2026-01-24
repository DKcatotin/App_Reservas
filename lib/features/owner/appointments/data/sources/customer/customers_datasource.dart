import '../../models/customer.dart';

/// Interface para obtener customers (local o remoto)
abstract class CustomersDatasource {
  Future<List<Customer>> getAll();
  Future<Customer?> getByTaxIdentification(String taxIdentification);
  Future<Customer?> getById(String id);
  //Future<Customer> create(Customer customer);
  //Future<Customer> update(Customer customer);
  //Future<void> delete(String id);
}
