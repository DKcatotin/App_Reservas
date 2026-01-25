import 'package:agenda_app/core/api/api_client.dart';
import 'package:agenda_app/core/errors/exceptions.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/status.dart';  // ✅ IMPORTAR
import 'package:flutter/foundation.dart';
import 'catalogues_datasource.dart';
import '../models/service.dart';

class CataloguesRemoteDatasource implements CataloguesDatasource {
  final ApiClient apiClient;
  
  CataloguesRemoteDatasource({required this.apiClient});

  @override
  Future<List<Service>> getServices() async {
    try {
      final response = await apiClient.get(
        '/core/owner/services',
        queryParameters: {
          'page': 1,
          'limit': 50,
        },
      );

      final data = response['data'] as List<dynamic>;
      
      if (data.isEmpty) {
        return [];
      }

      final services = <Service>[];
      
      for (final item in data) {
        try {
          final json = item as Map<String, dynamic>;
          debugPrint('📍 Parseando servicio: ${json['name']}');
          
          final service = Service.fromJson(json);
          services.add(service);
        } catch (e) {
          debugPrint('⚠️ Error parseando servicio: $e');
          continue;
        }
      }

      debugPrint('✅ Servicios parseados: ${services.length}');
      return services;
      
    } catch (e) {
      debugPrint('❌ Error en getServices: $e');
      throw ServerException('Error al obtener servicios: $e');
    }
  }

  @override
  Future<List<Staff>> getStaff() async {
    try {
      final response = await apiClient.get('/staff');
      
      final data = response['data'] as List<dynamic>;
      
      return data
          .map((json) => Staff.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Error al obtener personal: $e');
    }
  }

  @override
  Future<List<CatalogueItem>> getAppointmentStatuses() async {
    try {
      final response = await apiClient.get('/test1');
      
      final data = response['data'] as List<dynamic>;
      
      return data
          .map((json) => CatalogueItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Error al obtener estados: $e');
    }
  }

  // ✅ NUEVO MÉTODO
 @override
  Future<List<Status>> getStatuses() async {
    try {
      final response = await apiClient.get(
        '/common/catalogues',
        queryParameters: {
          'type': 'appointment_status',
          'page': 1,
          'limit': 10,
        },
      );

      final data = response['data'] as List<dynamic>;
      
      if (data.isEmpty) {
        debugPrint('⚠️ No hay statuses disponibles');
        return [];
      }

      final statuses = <Status>[];
      
      for (final item in data) {
        try {
          final json = item as Map<String, dynamic>;
          debugPrint('📍 Status: ${json['code']} - ID: ${json['id']}');
          
          final status = Status.fromJson(json);
          statuses.add(status);
        } catch (e) {
          debugPrint('⚠️ Error parseando status: $e');
          continue;
        }
      }

      statuses.sort((a, b) => a.code.compareTo(b.code));
      
      debugPrint('✅ Statuses cargados: ${statuses.length}');
      return statuses;
      
    } catch (e) {
      debugPrint('❌ Error al obtener statuses: $e');
      throw ServerException('Error al obtener statuses: $e');
    }
  }
}