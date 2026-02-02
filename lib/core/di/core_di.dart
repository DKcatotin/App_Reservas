import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

/// Dependencias core compartidas por todos los módulos
class CoreDependencies {
  late final TokenStorage tokenStorage;
  late final Dio dio;

  /// Inicializa usando las instancias globales creadas en main().
  /// Regla del proyecto: Dio y TokenStorage se crean SOLO una vez.
  void init({
    required TokenStorage tokenStorage,
    required Dio dio,
  }) {
    this.tokenStorage = tokenStorage;
    this.dio = dio;
  }
}
