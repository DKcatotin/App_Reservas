class Env {
  // Tipo de entorno
  static const Environment environment = Environment.development;

  // URLs según el entorno
  static String get baseUrl {
    switch (environment) {
      case Environment.development:
        return _developmentUrl;
      case Environment.staging:
        return _stagingUrl;
      case Environment.production:
        return _productionUrl;
    }
  }

  // URLs específicas
  // Android emulator: 10.0.2.2
  // iOS simulator: localhost
  // Dispositivo físico: IP de tu máquina en la red local
  static const String _developmentUrl = 'http://10.0.2.2:3000/api/v1';
  static const String _stagingUrl = 'https://staging.tuapp.com/api/v1';
  static const String _productionUrl = 'https://api.tuapp.com/api/v1';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Configuraciones adicionales
  static const bool enableLogging = true;
}

enum Environment {
  development,
  staging,
  production,
}
