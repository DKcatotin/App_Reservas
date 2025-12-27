import 'package:dio/dio.dart';

import '../networking/dio_client.dart';
import '../storage/token_storage.dart';

import '../../features/auth/data/sources/auth/auth_api.dart';
import '../../features/auth/data/repositories/auth/auth_repository.dart';

import '../../features/owner/appointments/data/sources/appointments_api.dart';
import '../../features/owner/appointments/data/sources/appointments_mock_api.dart';
import '../../features/owner/appointments/data/repositories/appointments_repository.dart';

class AppDependencies {
  final TokenStorage tokenStorage;
  final Dio dio;

  final AuthRepository authRepository;
  final AppointmentsRepository appointmentsRepository;

  AppDependencies._({
    required this.tokenStorage,
    required this.dio,
    required this.authRepository,
    required this.appointmentsRepository,
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

    // Appointments
    final appointmentsApi = AppointmentsApi(dio);
    final appointmentsMockApi = AppointmentsMockApi();

    final appointmentsRepository = AppointmentsRepository(
      api: appointmentsApi,
      mockApi: appointmentsMockApi,
    );

    return AppDependencies._(
      tokenStorage: tokenStorage,
      dio: dio,
      authRepository: authRepository,
      appointmentsRepository: appointmentsRepository,
    );
  }
}
