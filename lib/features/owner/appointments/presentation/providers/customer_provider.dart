import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/customer.dart';
import '../../data/sources/customers_datasource.dart';

/// Customer state
class CustomerState {  //  CAMBIO
  final Customer? customer;  //  CAMBIO
  final bool isLoading;  //  CAMBIO
  final String? error;

  CustomerState({
    this.customer,
    this.isLoading = false,
    this.error,
  });

  CustomerState copyWith({
    Customer? customer,
    bool? isLoading,  //  CAMBIO
    String? error,
  }) {
    return CustomerState(
      customer: customer ?? this.customer,
      isLoading: isLoading ?? this.isLoading,  //  CAMBIO
      error: error ?? this.error,
    );
  }
}

/// Notifier to manage customer state
class CustomerNotifier extends StateNotifier<CustomerState> {  //  CAMBIO
  final CustomersDatasource datasource;

  CustomerNotifier(this.datasource) : super(CustomerState());

  /// Search customer by tax identification
  Future<void> searchByTaxIdentification(String taxIdentification) async {  //  CAMBIO
    state = CustomerState(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 300));

    final customerFound = await datasource.getByTaxIdentification(taxIdentification);  //  CAMBIO

    if (customerFound != null) {
      state = CustomerState(customer: customerFound);
    } else {
      state = CustomerState(error: 'Cliente no encontrado');
    }
  }

  /// Create new customer in memory (optional, local cache only)
  Future<void> createCustomer({  //  CAMBIO
    required String taxIdentification,
    required String fullName,
    required String phone,
    String? email,
  }) async {
    state = CustomerState(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 300));

    final newCustomer = Customer(  //  CAMBIO
      id: taxIdentification,
      taxIdentification: taxIdentification,
      fullName: fullName,
      phone: phone,
      email: email,
    );

    await datasource.add(newCustomer);

    state = CustomerState(customer: newCustomer);
  }

  /// Clear state
  void clear() {  //  CAMBIO
    state = CustomerState();
  }
}

/// Datasource provider
final customersDatasourceProvider = Provider<CustomersDatasource>((ref) {
  return CustomersDatasource();
});

/// Customer state provider
final customerProvider =  // CAMBIO
    StateNotifierProvider<CustomerNotifier, CustomerState>((ref) {  //  CAMBIO
  final datasource = ref.watch(customersDatasourceProvider);
  return CustomerNotifier(datasource);
});
