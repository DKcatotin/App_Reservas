import 'package:agenda_app/core/di/riverpod_providers.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';
import 'package:agenda_app/features/owner/catalogues/data/sources/services_remotedatasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider del datasource de servicios
final servicesRemoteDatasourceProvider = Provider<ServicesRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider);
  return ServicesRemoteDatasource(dio);
});

/// Provider para obtener la lista de servicios
final servicesListProvider = FutureProvider<List<Service>>((ref) async {
  final datasource = ref.watch(servicesRemoteDatasourceProvider);
  return await datasource.getAll();
});