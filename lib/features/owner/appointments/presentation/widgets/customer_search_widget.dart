import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/customer_provider.dart';

class SearchCustomerWidget extends ConsumerStatefulWidget {  // ✅ CAMBIO
  const SearchCustomerWidget({super.key});  // ✅ CAMBIO

  @override
  ConsumerState<SearchCustomerWidget> createState() =>  // ✅ CAMBIO
      _SearchCustomerWidgetState();  // ✅ CAMBIO
}

class _SearchCustomerWidgetState extends ConsumerState<SearchCustomerWidget> {  //  CAMBIO
  final _taxIdController = TextEditingController();  //  CAMBIO
  final _fullNameController = TextEditingController();  //  CAMBIO
  final _phoneController = TextEditingController();  //  CAMBIO

  bool _customerExists = false;  //  CAMBIO
  bool _showForm = false;  //  CAMBIO

  @override
  void dispose() {
    _taxIdController.dispose();  //  CAMBIO
    _fullNameController.dispose();  //  CAMBIO
    _phoneController.dispose();  //  CAMBIO
    super.dispose();
  }

  Future<void> _searchCustomer() async {  //  CAMBIO
    final taxId = _taxIdController.text.trim();  //  CAMBIO

    if (taxId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese una cédula')),
      );
      return;
    }

    // Search customer
    await ref.read(customerProvider.notifier).searchByTaxIdentification(taxId);  // ✅ CAMBIO

    final state = ref.read(customerProvider);

    if (state.customer != null) {
      // Customer found, fill fields
      setState(() {
        _fullNameController.text = state.customer!.fullName ?? '';  //  CAMBIO
        _phoneController.text = state.customer!.phone ?? '';  //  CAMBIO
        _customerExists = true;  //  CAMBIO
        _showForm = true;  //  CAMBIO
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(' Cliente encontrado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      // Customer doesn't exist, clear to create new one
      setState(() {
        _fullNameController.clear();  //  CAMBIO
        _phoneController.clear();  //  CAMBIO
        _customerExists = false;  // CAMBIO
        _showForm = true;  //  CAMBIO
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente no encontrado. Complete los datos para crearlo'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _saveNewCustomer() async {  //  CAMBIO
    final taxId = _taxIdController.text.trim();  //  CAMBIO
    final fullName = _fullNameController.text.trim();  //  CAMBIO
    final phone = _phoneController.text.trim();  //  CAMBIO

    if (fullName.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }
/*
    await ref.read(customerProvider.notifier).createCustomer(
          taxIdentification: taxId,  //  CAMBIO
          fullName: fullName,  //  CAMBIO
          phone: phone,  //  CAMBIO
        );
*/
    setState(() {
      _customerExists = true;  // CAMBIO
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Cliente creado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerProvider);  //  CAMBIO

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tax ID search field
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _taxIdController,  //  CAMBIO
                decoration: const InputDecoration(
                  labelText: 'Cédula del cliente',
                  hintText: '1712345678',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: customerState.isLoading ? null : _searchCustomer,  //  CAMBIO
              icon: customerState.isLoading  //  CAMBIO
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              tooltip: 'Buscar cliente',
            ),
          ],
        ),

        // Show form if searched
        if (_showForm) ...[  //  CAMBIO
          const SizedBox(height: 16),
          TextField(
            controller: _fullNameController,  //  CAMBIO
            decoration: InputDecoration(
              labelText: 'Nombre completo',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
              enabled: !_customerExists,  //  CAMBIO
              suffixIcon: _customerExists  //  CAMBIO
                  ? const Icon(Icons.lock, color: Colors.grey)
                  : null,
            ),
            readOnly: _customerExists,  //  CAMBIO
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,  //  CAMBIO
            decoration: InputDecoration(
              labelText: 'Celular',
              hintText: '0998765432',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.phone),
              enabled: !_customerExists,  //  CAMBIO
              suffixIcon: _customerExists  //  CAMBIO
                  ? const Icon(Icons.lock, color: Colors.grey)
                  : null,
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            readOnly: _customerExists,  //  CAMBIO
          ),
          
          // Button to create new customer
          if (!_customerExists) ...[  //  CAMBIO
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _saveNewCustomer,  //  CAMBIO
              icon: const Icon(Icons.person_add),
              label: const Text('Crear cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
