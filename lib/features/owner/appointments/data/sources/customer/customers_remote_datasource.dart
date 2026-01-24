import 'package:agenda_app/core/logger/app_logger.dart';
import 'package:dio/dio.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../models/customer.dart';
import 'customers_datasource.dart';

/// Implementación remota usando API del backend
class CustomersRemoteDatasource implements CustomersDatasource {
  final Dio client; 
  static const String _baseEndpoint = '/core/owner/customers';

  CustomersRemoteDatasource({required this.client});

  @override
  Future<List<Customer>> getAll() async {
    try {
      AppLogger.d('GET Request: $_baseEndpoint'); // DEBUG
      
      final response = await client.get(_baseEndpoint);
      
      AppLogger.d('Response Status: ${response.statusCode}'); // DEBUG
      AppLogger.d('Response Data: ${response.data}'); // DEBUG

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Ajustar según estructura de tu backend
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => Customer.fromJson(json)).toList();
      }

      throw ServerException('Error al obtener customers: ${response.statusCode}');
    } on DioException catch (e) {
      AppLogger.d('DioException: ${e.message}'); // DEBUG
      AppLogger.d('Response: ${e.response?.data}'); // DEBUG
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ServerException('Tiempo de espera agotado');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const ServerException('Error de conexión');
      }
      throw ServerException('Error al obtener customers: ${e.message}');
    } catch (e) {
      AppLogger.d('Error inesperado: $e'); // DEBUG
      throw ServerException('Error inesperado: $e');
    }
  }

@override
Future<Customer?> getByTaxIdentification(String taxIdentification) async {
  try {
    final endpoint = '$_baseEndpoint/$taxIdentification/exist';
    AppLogger.d('[REMOTE] GET $endpoint');

    final response = await client.get(endpoint);

    AppLogger.d('[REMOTE] Status: ${response.statusCode}');
    AppLogger.d('[REMOTE] Data: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data['data'] as Map<String, dynamic>?;

      if (data == null) return null;

      final exists = data['exists'] == true;
      if (!exists) return null;

      final customerJson = data['customer'] as Map<String, dynamic>?;
      if (customerJson == null) return null;

      return Customer.fromJson(customerJson);
    }

    throw ServerException('Error al buscar customer: ${response.statusCode}');
  } on DioException catch (e) {
    AppLogger.d('[REMOTE] DioException: ${e.message}');
    AppLogger.d('[REMOTE] Response: ${e.response?.data}');

    if (e.response?.statusCode == 404) {
      return null;
    }

    throw ServerException('Error al buscar customer: ${e.message}');
  } catch (e) {
    AppLogger.d('[REMOTE] Error inesperado: $e');
    throw ServerException('Error inesperado: $e');
  }
}

  @override
  Future<Customer?> getById(String id) async {
    try {
      AppLogger.d('GET Request: $_baseEndpoint/$id'); // DEBUG
      
      final response = await client.get('$_baseEndpoint/$id');

      AppLogger.d('Response Status: ${response.statusCode}'); // DEBUG
      AppLogger.d('Response Data: ${response.data}'); // DEBUG

      if (response.statusCode == 200 || response.statusCode == 201) {
        final customerData = response.data['data'] ?? response.data;
        return Customer.fromJson(customerData);
      } else if (response.statusCode == 404) {
        return null;
      }

      throw ServerException('Error al obtener customer: ${response.statusCode}');
    } on DioException catch (e) {
      AppLogger.d('DioException: ${e.message}'); // DEBUG
      
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ServerException('Error al obtener customer: ${e.message}');
    } catch (e) {
      AppLogger.d('Error inesperado: $e'); // DEBUG
      throw ServerException('Error inesperado: $e');
    }
  }
/*
  @override
  Future<Customer> create(Customer customer) async {
    try {
      final response = await client.post(
        _baseEndpoint,
        data: customer.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Customer.fromJson(response.data['data'] ?? response.data);
      }

      throw ServerException('Error al crear customer: ${response.statusCode}');
    } catch (e) {
      throw ServerException('Error al crear customer: $e');
    }
  }

  @override
  Future<Customer> update(Customer customer) async {
    try {
      final response = await client.put(
        '$_baseEndpoint/${customer.id}',
        data: customer.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Customer.fromJson(response.data['data'] ?? response.data);
      }

      throw ServerException('Error al actualizar customer: ${response.statusCode}');
    } catch (e) {
      throw ServerException('Error al actualizar customer: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final response = await client.delete('$_baseEndpoint/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Error al eliminar customer: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Error al eliminar customer: $e');
    }
  }
*/
}
