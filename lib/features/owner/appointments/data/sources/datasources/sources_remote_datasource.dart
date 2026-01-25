import 'package:agenda_app/core/api/api_client.dart';
import 'package:agenda_app/core/logger/app_logger.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/datasources/source_datasource.dart';
import 'package:flutter/foundation.dart';
import '../../models/source.dart';

class SourcesRemoteDatasource implements SourcesDatasource {
  final ApiClient apiClient;

  SourcesRemoteDatasource({required this.apiClient});

 @override
Future<List<Source>> getSources({String? type}) async {
  try {
    final response = await apiClient.get(
      '/common/catalogues',
      queryParameters: {
        'type': 'appointment_source',
        'page': 1,
        'limit': 10,
      },
    );

    final data = response['data'] as List<dynamic>?;
    
    if (data == null || data.isEmpty) {
      debugPrint('⚠️ No hay sources disponibles');
      return [];
    }
    
    final sources = <Source>[];
    
    for (final item in data) {
      try {
        final json = item as Map<String, dynamic>;
        
        // Log para debug
        debugPrint('📍 Parseando source: ${json['code']}');
        
        final source = Source.fromJson(json);
        sources.add(source);
      } catch (e) {
        debugPrint('⚠️ Error parseando un source: $e');
        // Continuar con el siguiente item
      }
    }
    
    sources.sort((a, b) => a.sort.compareTo(b.sort));
    
    debugPrint('✅ Sources cargados: ${sources.length}');
    return sources;
      
  } catch (e) {
    debugPrint('❌ Error al obtener sources: $e');
    return [];
  }
}

}


