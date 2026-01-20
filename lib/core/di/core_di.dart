import 'package:dio/dio.dart';
import '../networking/dio_client.dart';
import '../storage/token_storage.dart';

/// Dependencias core compartidas por todos los módulos
class CoreDependencies {
  late final TokenStorage tokenStorage;
  late final Dio dio;

  void init() {
    tokenStorage = TokenStorage();
    dio = DioClient.create(tokenStorage);
  }
}
