import 'package:agenda_app/core/api/api_client.dart';
import 'package:agenda_app/core/di/appointments_di.dart';
import 'package:agenda_app/core/networking/dio_client.dart';
import 'package:agenda_app/features/owner/appointments/data/models/source.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/datasources/sources_remote_datasource.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/catalogues/data/datasources/catalogues_remote_datasource.dart';
import 'package:agenda_app/features/owner/catalogues/data/models/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/source_entity.dart';
import '../../domain/inputs/create_appointement_input.dart';
import '../../domain/use_cases/create_appointment.dart';
import '../../data/repositories/appointments_repository_impl.dart';
import '../../../catalogues/domain/entities/service_entity.dart';

// Provider para Dio
final dioProvider = Provider<Dio>((ref) {
  return DioClient.instance;
});

// Provider para ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio: dio);
});

// Provider para AppointmentsDependencies
final appointmentsDependenciesProvider = Provider<AppointmentsDependencies>((ref) {
  final dio = ref.watch(dioProvider);
  return AppointmentsDependencies()..init(dio);
});

// Provider principal
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

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  /// Cargar servicios y sources
  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cataloguesRemote = CataloguesRemoteDatasource(apiClient: apiClient);
      final sourcesRemote = SourcesRemoteDatasource(apiClient: apiClient);

      // CARGAR SERVICIOS (REQUERIDO)
      try {
        final servicesList = await cataloguesRemote.getServices();
        services = (servicesList as List<Service>)
            .map((s) => s.toEntity())
            .toList();
        debugPrint('✅ Servicios cargados: ${services.length}');
      } catch (e) {
        debugPrint('❌ Error cargando servicios: $e');
        errorMessage = 'Error al cargar servicios: $e';
        throw Exception('Servicios: $e');
      }

      // CARGAR SOURCES (OPCIONAL - no bloquea si falla)
      try {
        final sourcesList = await sourcesRemote.getSources();
        sources = (sourcesList as List<Source>)
            .map((s) => s.toEntity())
            .toList();
        debugPrint('✅ Sources cargados: ${sources.length}');
      } catch (e) {
        debugPrint('⚠️ Error al cargar sources (continuando sin ellos): $e');
        sources = []; // Dejar vacío pero no fallar
      }
    } catch (e) {
      errorMessage = 'Error cargando datos: $e';
      debugPrint('❌ Error cargando datos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Crear una cita
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
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  /// Obtener todas las citas
  Future<List<AppointmentEntity>> getAllAppointments() async {
    try {
      return await appointmentsRepository.getAll();
    } catch (e) {
      errorMessage = 'Error obteniendo citas: $e';
      debugPrint('❌ Error obteniendo citas: $e');
      return [];
    }
  }

  /// Limpiar errores
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
