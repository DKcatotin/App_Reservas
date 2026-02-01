import 'package:agenda_app/core/di/app_dependencies.dart';
import 'package:agenda_app/core/storage/token_storage.dart';
import 'package:agenda_app/core/networking/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);

  final tokenStorage = TokenStorage();
  final dio = DioClient.create(tokenStorage);
  DioClient.setInstance(dio);

  // ✅ Bootstrap único de dependencias (evita duplicación de Dio/TokenStorage)
  AppDependencies().bootstrap(dio: dio, tokenStorage: tokenStorage);

  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}
