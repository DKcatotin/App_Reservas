import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/customer.dart';
import '../../data/sources/customers_datasource.dart';

/// Estado del cliente
class ClienteState {
  final Customer? cliente;
  final bool cargando;
  final String? error;

  ClienteState({
    this.cliente,
    this.cargando = false,
    this.error,
  });

  ClienteState copyWith({
    Customer? cliente,
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
  final CustomersDatasource datasource;

  ClienteNotifier(this.datasource) : super(ClienteState());

  /// Buscar cliente por cédula
  Future<void> buscarPorCedula(String cedula) async {
    state = ClienteState(cargando: true);

    await Future.delayed(const Duration(milliseconds: 300));

    final clienteEncontrado = await datasource.getByCedula(cedula);

    if (clienteEncontrado != null) {
      state = ClienteState(cliente: clienteEncontrado);
    } else {
      state = ClienteState(error: 'Cliente no encontrado');
    }
  }

  /// Crear nuevo cliente en memoria (opcional, solo cache local)
  Future<void> crearCliente({
  required String cedula,
  required String nombre,
  required String celular,
}) async {
  state = ClienteState(cargando: true);

  await Future.delayed(const Duration(milliseconds: 300));

  final nuevoCliente = Customer(
    id: cedula,    // mock: usamos la cédula como id
    cedula: cedula,
    nombre: nombre,
    celular: celular,
  );

  await datasource.add(nuevoCliente);

  state = ClienteState(cliente: nuevoCliente);
}

  /// Limpiar el estado
  void limpiar() {
    state = ClienteState();
  }
}

/// Provider del datasource
final customersDatasourceProvider = Provider<CustomersDatasource>((ref) {
  return CustomersDatasource();
});

/// Provider del estado del cliente
final clienteProvider =
    StateNotifierProvider<ClienteNotifier, ClienteState>((ref) {
  final datasource = ref.watch(customersDatasourceProvider);
  return ClienteNotifier(datasource);
});
