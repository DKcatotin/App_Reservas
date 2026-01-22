import 'package:dio/dio.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../models/customer.dart';
import 'customers_datasource.dart';

/// Implementación remota usando API del backend
class CustomersRemoteDatasource implements CustomersDatasource {
  final Dio client;
  
  // ⚠️ AJUSTA ESTA RUTA SEGÚN TU BACKEND
  static const String _baseEndpoint = 'core/owner/customers';

  CustomersRemoteDatasource({required this.client});

  @override
  Future<List<Customer>> getAll() async {
    try {
      print('🔵 GET Request: $_baseEndpoint'); // DEBUG
      
      final response = await client.get(_baseEndpoint);
      
      print('🔵 Response Status: ${response.statusCode}'); // DEBUG
      print('🔵 Response Data: ${response.data}'); // DEBUG

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Ajustar según estructura de tu backend
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => Customer.fromJson(json)).toList();
      }

      throw ServerException('Error al obtener customers: ${response.statusCode}');
    } on DioException catch (e) {
      print('🔴 DioException: ${e.message}'); // DEBUG
      print('🔴 Response: ${e.response?.data}'); // DEBUG
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ServerException('Tiempo de espera agotado');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const ServerException('Error de conexión');
      }
      throw ServerException('Error al obtener customers: ${e.message}');
    } catch (e) {
      print('🔴 Error inesperado: $e'); // DEBUG
      throw ServerException('Error inesperado: $e');
    }
  }

 @override
Future<Customer?> getByTaxIdentification(String taxIdentification) async {
  try {
    print('🔵 [DATASOURCE] Buscando customer por cédula: $taxIdentification');
    
    // Obtener todos y filtrar
    print('🔵 [DATASOURCE] Obteniendo todos los customers...');
    
    final customers = await getAll();
    
    print('🔵 [DATASOURCE] Total customers recibidos: ${customers.length}');
    
    // Debug: Mostrar todas las cédulas disponibles
    for (var c in customers) {
      print('🔍 [DATASOURCE] Customer: ${c.fullName} - Cédula: ${c.taxIdentification}');
    }
    
    try {
      final found = customers.firstWhere(
        (c) {
          print('🔍 [DATASOURCE] Comparando: "${c.taxIdentification}" == "$taxIdentification"');
          return c.taxIdentification == taxIdentification;
        },
      );
      print('🟢 [DATASOURCE] Customer encontrado: ${found.fullName}');
      return found;
    } catch (_) {
      print('🟡 [DATASOURCE] Customer no encontrado con cédula: $taxIdentification');
      print('🟡 [DATASOURCE] Total customers buscados: ${customers.length}');
      return null;
    }
  } catch (e, stackTrace) {
    print('🔴 [DATASOURCE] Error: $e');
    print('🔴 [DATASOURCE] StackTrace: $stackTrace');
    rethrow;
  }
}

  @override
  Future<Customer?> getById(String id) async {
    try {
      print('🔵 GET Request: $_baseEndpoint/$id'); // DEBUG
      
      final response = await client.get('$_baseEndpoint/$id');

      print('🔵 Response Status: ${response.statusCode}'); // DEBUG
      print('🔵 Response Data: ${response.data}'); // DEBUG

      if (response.statusCode == 200 || response.statusCode == 201) {
        final customerData = response.data['data'] ?? response.data;
        return Customer.fromJson(customerData);
      } else if (response.statusCode == 404) {
        return null;
      }

      throw ServerException('Error al obtener customer: ${response.statusCode}');
    } on DioException catch (e) {
      print('🔴 DioException: ${e.message}'); // DEBUG
      
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw ServerException('Error al obtener customer: ${e.message}');
    } catch (e) {
      print('🔴 Error inesperado: $e'); // DEBUG
      throw ServerException('Error inesperado: $e');
    }
  }

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
}
