import 'package:agenda_app/core/api/api_client.dart';
import 'package:agenda_app/core/di/appointments_di.dart';
import 'package:agenda_app/core/networking/dio_client.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/datasources/sources_remote_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/sources/catalogues_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Central DI providers for Riverpod usage.
final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio: dio);
});

final cataloguesRemoteDatasourceProvider =
    Provider<CataloguesRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CataloguesRemoteDatasource(apiClient: apiClient);
});

final sourcesRemoteDatasourceProvider =
    Provider<SourcesRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SourcesRemoteDatasource(apiClient: apiClient);
});

final appointmentsDependenciesProvider = Provider<AppointmentsDependencies>((ref) {
  final dio = ref.watch(dioProvider);
  return AppointmentsDependencies()..init(dio);
});
