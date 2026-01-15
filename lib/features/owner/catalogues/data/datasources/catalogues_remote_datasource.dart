import 'package:agenda_app/features/owner/catalogues/data/models/catalogue_item.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/staff.dart';
import 'package:dio/dio.dart';
import 'catalogues_datasource.dart';
import '../models/service.dart';

/// Datasource que obtiene catálogos desde API REST.
/// TODO(backend): Implementar llamadas HTTP cuando el backend esté listo.
class CataloguesRemoteDatasource implements CataloguesDatasource {
   final Dio dio;
   CataloguesRemoteDatasource(this.dio);
  // TODO(backend): Inyectar Dio o http client
  // final Dio _dio;
  // CataloguesRemoteDatasource(this._dio);

  @override
  Future<List<Service>> getServices() async {
    // TODO(backend): Reemplazar con llamada real
    // final response = await _dio.get('/api/services');
    // return (response.data as List)
    //     .map((e) => Service.fromJson(e))
    //     .toList();

    throw UnimplementedError(
      'CataloguesRemoteDatasource.getServices() requiere backend.\n'
      'Conecta endpoint GET /api/services y descomenta implementación.',
    );
  }

  @override
  Future<List<Staff>> getStaff() async {
    // TODO(backend): Reemplazar con llamada real
    // final response = await _dio.get('/api/staff');
    // return (response.data as List)
    //     .map((e) => Staff.fromJson(e))
    //     .toList();

    throw UnimplementedError(
      'CataloguesRemoteDatasource.getStaff() requiere backend.\n'
      'Conecta endpoint GET /api/staff y descomenta implementación.',
    );
  }
   ///  Ruta privada usada antes en `/test1`
  @override
  Future<List<CatalogueItem>> getAppointmentStatuses() async {
    final res = await dio.get('/test1');

    final data = res.data['data'] as List<dynamic>;

    return data
        .map((e) => CatalogueItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
