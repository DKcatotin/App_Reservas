import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer_model.dart';
import '../../data/repositories/cliente_mock_repository.dart';

/// Estado del cliente
class ClienteState {
  final ClienteModel? cliente;
  final bool cargando;
  final String? error;

  ClienteState({
    this.cliente,
    this.cargando = false,
    this.error,
  });

  ClienteState copyWith({
    ClienteModel? cliente,
    bool? cargando,
    String? error,
  }) {
    return ClienteState(
      cliente: cliente ?? this.cliente,
      cargando: cargando ?? this.cargando,
      error: error ?? this.error,
    );
  }
}

/// Notifier para gestionar el estado del cliente
class ClienteNotifier extends StateNotifier<ClienteState> {
  final ClienteMockRepository repository;

  ClienteNotifier(this.repository) : super(ClienteState());

  /// Buscar cliente por cédula
  Future<void> buscarPorCedula(String cedula) async {
    state = ClienteState(cargando: true);

    // Simular latencia de red
    await Future.delayed(const Duration(milliseconds: 300));

    final clienteEncontrado = repository.buscarPorCedula(cedula);

    if (clienteEncontrado != null) {
      state = ClienteState(cliente: clienteEncontrado);
    } else {
      state = ClienteState(error: 'Cliente no encontrado');
    }
  }

  /// Crear nuevo cliente
  Future<void> crearCliente({
    required String cedula,
    required String nombre,
    required String celular,
  }) async {
    state = ClienteState(cargando: true);

    await Future.delayed(const Duration(milliseconds: 300));

    final nuevoCliente = repository.crearCliente(
      cedula: cedula,
      nombre: nombre,
      celular: celular,
    );

    state = ClienteState(cliente: nuevoCliente);
  }

  /// Limpiar el estado
 void limpiar() {
  state = ClienteState();
}
}

/// Provider del repositorio
final clienteRepositoryProvider = Provider<ClienteMockRepository>((ref) {
  return ClienteMockRepository();
});

/// Provider del estado del cliente
final clienteProvider = StateNotifierProvider<ClienteNotifier, ClienteState>((ref) {
  final repository = ref.watch(clienteRepositoryProvider);
  return ClienteNotifier(repository);
});
