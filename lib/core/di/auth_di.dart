import 'package:dio/dio.dart';

import '../networking/dio_client.dart';
import '../storage/token_storage.dart';

import '../../features/auth/data/sources/auth/auth_api.dart';
import '../../features/auth/data/repositories/auth/auth_repository.dart';

import '../../features/owner/appointments/data/repositories/appointments_repository.dart';
import '../../features/owner/appointments/data/sources/appointments_json_datasource.dart';

import '../../features/owner/catalogues/data/repositories/catalogues_repository.dart';
import '../../features/owner/catalogues/data/sources/catalogues_api_datasource.dart';
import '../../features/owner/appointments/data/sources/appointments_memory_datasource.dart';
import '../../features/owner/appointments/data/sources/appointments_hybrid_datasource.dart';


class AppDependencies {
  final TokenStorage tokenStorage;
  final Dio dio;

  final AuthRepository authRepository;
  final AppointmentsRepository appointmentsRepository;
  final CataloguesRepository cataloguesRepository;

  AppDependencies._({
    required this.tokenStorage,
    required this.dio,
    required this.authRepository,
    required this.appointmentsRepository,
    required this.cataloguesRepository,
  });

  factory AppDependencies.build() {
    final tokenStorage = TokenStorage();
    final dio = DioClient.create(tokenStorage);

    // Auth
    final authApi = AuthApi(dio);
    final authRepository = AuthRepository(
      api: authApi,
      tokenStorage: tokenStorage,
    );

    // Catalogues (API real)
    final cataloguesApi = CataloguesApiDatasource(dio);
    final cataloguesRepository = CataloguesRepository(
      api: cataloguesApi,
    );

    // Appointments (JSON quemado)
    // Appointments (JSON + memoria)
final appointmentsDatasource = AppointmentsHybridDatasource(
  json: AppointmentsJsonDatasource(),
  memory: AppointmentsMemoryDatasource(),
);

final appointmentsRepository = AppointmentsRepository(
  datasource: appointmentsDatasource,
);

    return AppDependencies._(
      tokenStorage: tokenStorage,
      dio: dio,
      authRepository: authRepository,
      appointmentsRepository: appointmentsRepository,
      cataloguesRepository: cataloguesRepository,
    );
  }
}
