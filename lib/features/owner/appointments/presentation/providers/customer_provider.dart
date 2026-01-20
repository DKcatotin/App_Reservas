import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer.dart';
import '../../data/sources/customers_datasource.dart';
import '../../data/sources/customers_local_datasource.dart'; // ← CAMBIO

/// Customer state
class CustomerState {
  final Customer? customer;
  final bool isLoading;
  final String? error;

  CustomerState({
    this.customer,
    this.isLoading = false,
    this.error,
  });

  CustomerState copyWith({
    Customer? customer,
    bool? isLoading,
    String? error,
  }) {
    return CustomerState(
      customer: customer ?? this.customer,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier to manage customer state
class CustomerNotifier extends StateNotifier<CustomerState> {
  final CustomersDatasource datasource;

  CustomerNotifier(this.datasource) : super(CustomerState());

  /// Search customer by tax identification
  Future<void> searchByTaxIdentification(String taxIdentification) async {
  print('🔵 [PROVIDER] Buscando customer por cédula: $taxIdentification'); // DEBUG
  state = CustomerState(isLoading: true);

  try {
    print('🔵 [PROVIDER] Llamando datasource...'); // DEBUG
    final customerFound = await datasource.getByTaxIdentification(taxIdentification);
    print('🔵 [PROVIDER] Resultado: ${customerFound?.fullName ?? "null"}'); // DEBUG

    if (customerFound != null) {
      state = CustomerState(customer: customerFound);
    } else {
      state = CustomerState(error: 'Cliente no encontrado');
    }
  } catch (e, stackTrace) {
    print('🔴 [PROVIDER] Error: $e'); // DEBUG
    print('🔴 [PROVIDER] StackTrace: $stackTrace'); // DEBUG
    state = CustomerState(error: 'Error al buscar cliente: $e');
  }
}
  /// Clear state
  void clear() {
    state = CustomerState();
  }
}

/// Datasource provider - Usa implementación local directamente
final customersDatasourceProvider = Provider<CustomersDatasource>((ref) {
  return CustomersLocalDatasource(); // ← CAMBIO: Instancia concreta
});

/// Customer state provider
final customerProvider =
    StateNotifierProvider<CustomerNotifier, CustomerState>((ref) {
  final datasource = ref.watch(customersDatasourceProvider);
  return CustomerNotifier(datasource);
});
