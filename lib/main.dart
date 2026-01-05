import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository.dart';
import 'package:agenda_app/features/owner/appointments/data/sources/appointments_memory_datasource.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es', null);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppointmentsRepository>(
          create: (_) => AppointmentsRepository(
            datasource: AppointmentsMemoryDatasource(),
          ),
        ),
      ],
      child: App(),
    ),
  );
}

