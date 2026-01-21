import 'package:agenda_app/core/networking/api_endpoints.dart';
import 'package:agenda_app/features/owner/appointments/data/models/customer.dart';
import 'package:dio/dio.dart';
import 'customers_datasource.dart';

class CustomersRemoteDatasource implements CustomersDatasource {
  final Dio dio;

  CustomersRemoteDatasource(this.dio);

@override
Future<Customer?> getByTaxIdentification(String taxIdentification) async {
  try {
    final res = await dio.get(
      '${ApiEndpoints.customersByTaxId}/$taxIdentification',
    );

    if (res.data == null || res.data['data'] == null) {
      return null;
    }

    final customerData = res.data['data'] as Map<String, dynamic>;
    return Customer.fromJson(customerData);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      return null;
    }
    rethrow;
  }
}

  @override
  Future<List<Customer>> searchCustomers(String query) async {
    try {
      final response = await dio.get(
        ApiEndpoints.customers,
        queryParameters: {'search': query},
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => Customer.fromJson(json)).toList();
      
    } catch (e) {
      rethrow;
    }
  }
  @override
Future<List<Customer>> getAll() async {
  final response = await dio.get(
    ApiEndpoints.customers,
    queryParameters: {
      'limit': 50, // o el valor que quieras
      'page': 1,
    },
  );

  final List<dynamic> data = response.data['data'] as List<dynamic>;
  return data
      .map((item) => Customer.fromJson(item as Map<String, dynamic>))
      .toList();
}

}
