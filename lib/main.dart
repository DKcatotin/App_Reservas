import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments_memory_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart' as classic_provider; // 👈 Añadir alias
import 'app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('es', null);
  
  runApp(
    ProviderScope(
      child: classic_provider.MultiProvider(  // 👈 Usar el alias
        providers: [
          classic_provider.Provider<AppointmentsRepository>(  // 👈 Usar el alias
            create: (_) => AppointmentsRepository(
              datasource: AppointmentsMemoryDatasource(),
            ),
          ),
        ],
        child: App(),
      ),
    ),
  );
}
