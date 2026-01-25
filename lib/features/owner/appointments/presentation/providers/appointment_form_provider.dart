import 'package:agenda_app/core/api/api_client.dart';
import 'package:agenda_app/core/di/appointments_di.dart';
import 'package:agenda_app/core/networking/dio_client.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/datasources/sources_remote_datasource.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/branches/domain/branch_entity.dart';
import 'package:agenda_app/features/owner/catalogues/data/datasources/catalogues_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/source_entity.dart';
import '../../domain/inputs/create_appointement_input.dart';
import '../../domain/use_cases/create_appointment.dart';
import '../../data/repositories/appointments_repository_impl.dart';
import '../../../catalogues/domain/entities/service_entity.dart';
import '../../../catalogues/domain/entities/status_entity.dart';  // ✅ IMPORTAR

final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio: dio);
});

final appointmentsDependenciesProvider = Provider<AppointmentsDependencies>((ref) {
  final dio = ref.watch(dioProvider);
  return AppointmentsDependencies()..init(dio);
});

final appointmentFormProvider =
    ChangeNotifierProvider<AppointmentFormProvider>((ref) {
  final deps = ref.watch(appointmentsDependenciesProvider);
  final apiClient = ref.watch(apiClientProvider);

  return AppointmentFormProvider(
    appointmentsRepository: deps.appointmentsRepository,
    createAppointmentUseCase: deps.createAppointmentUseCase,
    apiClient: apiClient,
  );
});

class AppointmentFormProvider extends ChangeNotifier {
  AppointmentFormProvider({
    required this.appointmentsRepository,
    required this.createAppointmentUseCase,
    required this.apiClient,
  });

  final AppointmentsRepositoryImpl appointmentsRepository;
  final CreateAppointmentUseCase createAppointmentUseCase;
  final ApiClient apiClient;

  List<ServiceEntity> services = [];
  List<SourceEntity> sources = [];
  List<StatusEntity> statuses = [];  // ✅ AGREGAR

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cataloguesRemote = CataloguesRemoteDatasource(apiClient: apiClient);
      final sourcesRemote = SourcesRemoteDatasource(apiClient: apiClient);

      // CARGAR SERVICIOS
      try {
        final servicesList = await cataloguesRemote.getServices();
        services = servicesList.map((s) => s.toEntity()).toList();
        debugPrint('✅ Servicios cargados: ${services.length}');
      } catch (e) {
        debugPrint('❌ Error cargando servicios: $e');
        errorMessage = 'Error al cargar servicios: $e';
        throw Exception('Servicios: $e');
      }

      // CARGAR SOURCES
      try {
        final sourcesList = await sourcesRemote.getSources(type: 'appointment_source');
        sources = sourcesList.map((s) => s.toEntity()).toList();
        debugPrint('✅ Sources cargados: ${sources.length}');
      } catch (e) {
        debugPrint('⚠️ Error al cargar sources: $e');
        sources = [];
      }

      // ✅ CARGAR STATUSES
      try {
        final statusesList = await cataloguesRemote.getStatuses();
        statuses = statusesList.map((s) => s.toEntity()).toList();
        debugPrint('✅ Statuses cargados: ${statuses.length}');
      } catch (e) {
        debugPrint('⚠️ Error al cargar statuses: $e');
        statuses = [];
      }

    } catch (e) {
      errorMessage = 'Error cargando datos: $e';
      debugPrint('❌ Error cargando datos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAppointment(CreateAppointmentInput input) async {
    if (isSaving) return;

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await createAppointmentUseCase.call(input);
      debugPrint('✅ Cita creada exitosamente');
    } catch (e) {
      errorMessage = 'Error creando cita: $e';
      debugPrint('❌ Error creando cita: $e');
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<List<AppointmentEntity>> getAllAppointments() async {
    try {
      return await appointmentsRepository.getAll();
    } catch (e) {
      errorMessage = 'Error obteniendo citas: $e';
      debugPrint('❌ Error obteniendo citas: $e');
      return [];
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}