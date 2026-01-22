import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments/appointments_memory_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart' as classic_provider; //  Añadir alias
import 'app.dart';

//inicializa conecta las piezas
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('es', null);

  runApp(
    ProviderScope(
      child: classic_provider.MultiProvider(  //  Usar el alias
        providers: [
          classic_provider.Provider<AppointmentsRepositoryImpl>(  //  Usar el alias
            create: (_) => AppointmentsRepositoryImpl(
              datasource: AppointmentsMemoryDatasource(),
            ),
          ),
        ],
        child: App(),
      ),
    ),
  );
}
