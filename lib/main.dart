import 'package:agenda_app/core/storage/token_storage.dart';
import 'package:agenda_app/core/networking/dio_client.dart';
import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointment_services_remote_datasource.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_memory_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart' as classic_provider;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es', null);

  // 1. Inicializar TokenStorage
  final tokenStorage = TokenStorage();

  // 2. Crear Dio con TokenStorage
  final dio = DioClient.create(tokenStorage);

  // 3. Guardar instancia global en DioClient
  DioClient.setInstance(dio);

  runApp(
    ProviderScope(
      child: classic_provider.MultiProvider(
        providers: [
          classic_provider.Provider<AppointmentsRepositoryImpl>(
            create: (_) => AppointmentsRepositoryImpl(
              remoteDatasource: AppointmentsMemoryDatasource(),
              servicesDataSource: AppointmentServicesRemoteDatasource(dio: dio),  // ✅ AGREGAR dio
            ),
          ),
        ],
        child:  App(),
      ),
    ),
  );
}
