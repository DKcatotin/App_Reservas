import 'package:dio/dio.dart';
import '../../features/owner/catalogues/data/datasources/catalogues_datasource.dart';
import '../../features/owner/catalogues/data/datasources/catalogues_local_datasource.dart';
import '../../features/owner/catalogues/data/repositories/catalogues_repository_impl.dart';
import '../../features/owner/catalogues/domain/repositories/catalogues_repository.dart';

/// Dependencias del módulo de catálogos
class CataloguesDependencies {
  late final CataloguesDatasource _cataloguesDatasource;
  late final CataloguesRepository cataloguesRepository;

  void init({required Dio dio}) {
    // (backend): cambiar a CataloguesRemoteDatasource(dio)
    _cataloguesDatasource = CataloguesLocalDatasource(dio);

    cataloguesRepository = CataloguesRepositoryImpl(
      datasource: _cataloguesDatasource,
    );
  }
}
