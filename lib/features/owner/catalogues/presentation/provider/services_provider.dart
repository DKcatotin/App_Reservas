import 'package:agenda_app/core/di/riverpod_providers.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para obtener la lista de servicios.
/// Infraestructura centralizada: usa CataloguesRemoteDatasource desde riverpod_providers.dart
final servicesListProvider = FutureProvider<List<Service>>((ref) async {
  final datasource = ref.watch(cataloguesRemoteDatasourceProvider);
  return datasource.getServices();
});
