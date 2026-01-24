import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/customer_provider.dart';

class SearchCustomerWidget extends ConsumerStatefulWidget { 
  const SearchCustomerWidget({super.key}); 

  @override
  ConsumerState<SearchCustomerWidget> createState() =>  
      _SearchCustomerWidgetState(); 
}

class _SearchCustomerWidgetState extends ConsumerState<SearchCustomerWidget> {  
  final _taxIdController = TextEditingController();  
  final _fullNameController = TextEditingController();  
  final _phoneController = TextEditingController();  

  bool _customerExists = false;  
  bool _showForm = false;  

  @override
  void dispose() {
    _taxIdController.dispose();  
    _fullNameController.dispose();  
    _phoneController.dispose();  
    super.dispose();
  }

  Future<void> _searchCustomer() async {  
    final taxId = _taxIdController.text.trim();  

    if (taxId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese una cédula')),
      );
      return;
    }

    // Search customer
    await ref.read(customerProvider.notifier).searchByTaxIdentification(taxId);  

    final state = ref.read(customerProvider);

    if (state.customer != null) {
      // Customer found, fill fields
      setState(() {
        _fullNameController.text = state.customer!.fullName ?? '';  
        _phoneController.text = state.customer!.phone ?? '';  
        _customerExists = true;  
        _showForm = true;  
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
        _fullNameController.clear();  
        _phoneController.clear();  
        _customerExists = false;  // CAMBIO
        _showForm = true;  
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

  Future<void> _saveNewCustomer() async {  
    final taxId = _taxIdController.text.trim();  
    final fullName = _fullNameController.text.trim();  
    final phone = _phoneController.text.trim();  

    if (fullName.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }
/*
    await ref.read(customerProvider.notifier).createCustomer(
          taxIdentification: taxId,  
          fullName: fullName,  
          phone: phone,  
        );
*/
    setState(() {
      _customerExists = true;  // CAMBIO
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(' Cliente creado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerProvider);  

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tax ID search field
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _taxIdController,  
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
              onPressed: customerState.isLoading ? null : _searchCustomer,  
              icon: customerState.isLoading  
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
        if (_showForm) ...[  
          const SizedBox(height: 16),
          TextField(
            controller: _fullNameController,  
            decoration: InputDecoration(
              labelText: 'Nombre completo',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person),
              enabled: !_customerExists,  
              suffixIcon: _customerExists  
                  ? const Icon(Icons.lock, color: Colors.grey)
                  : null,
            ),
            readOnly: _customerExists,  
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,  
            decoration: InputDecoration(
              labelText: 'Celular',
              hintText: '0998765432',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.phone),
              enabled: !_customerExists,  
              suffixIcon: _customerExists  
                  ? const Icon(Icons.lock, color: Colors.grey)
                  : null,
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            readOnly: _customerExists,  
          ),
          
          // Button to create new customer
          if (!_customerExists) ...[  
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _saveNewCustomer,  
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
