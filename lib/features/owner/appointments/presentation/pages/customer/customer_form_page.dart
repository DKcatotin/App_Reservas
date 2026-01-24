import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/customer_provider.dart';
//Formalurio para agregar clientes 

class ClienteFormPage extends ConsumerStatefulWidget {
  final String? cedulaPrellenada;

  const ClienteFormPage({super.key, this.cedulaPrellenada});

  @override
  ConsumerState<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends ConsumerState<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _celularController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cedulaPrellenada != null) {
      _cedulaController.text = widget.cedulaPrellenada!;
    }
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _celularController.dispose();
    super.dispose();
  }

  Future<void> _guardarCliente() async {
  if (!_formKey.currentState!.validate()) return;
/*
  await ref.read(customerProvider.notifier).createCustomer(
    taxIdentification: _cedulaController.text.trim(),  // 
    fullName: _nombreController.text.trim(),           //  
    phone: _celularController.text.trim(),             // 
  );

  final clienteCreado = ref.read(customerProvider).customer;

  if (mounted && clienteCreado != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(' Cliente creado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context, clienteCreado);
  }
  */
}

  @override
  Widget build(BuildContext context) {
    final clienteState = ref.watch(customerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Cliente'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Icono decorativo
            Icon(
              Icons.person_add_alt_1,
              size: 80,
              color: Theme.of(context).primaryColor.withValues(alpha:0.5),
            ),
            const SizedBox(height: 24),

            const Text(
              'Complete los datos del cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Cédula
            TextFormField(
              controller: _cedulaController,
              decoration: const InputDecoration(
                labelText: 'Cédula *',
                hintText: '1712345678',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
              readOnly: widget.cedulaPrellenada != null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La cédula es obligatoria';
                }
                if (value.length != 10) {
                  return 'La cédula debe tener 10 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Nombre
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo *',
                hintText: 'Juan Pérez',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es obligatorio';
                }
                if (value.length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Celular
            TextFormField(
              controller: _celularController,
              decoration: const InputDecoration(
                labelText: 'Celular *',
                hintText: '0998765432',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El celular es obligatorio';
                }
                if (value.length != 10) {
                  return 'El celular debe tener 10 dígitos';
                }
                if (!value.startsWith('09')) {
                  return 'El celular debe empezar con 09';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Botón guardar
            ElevatedButton.icon(
              onPressed: clienteState.isLoading ? null : _guardarCliente,
              icon: clienteState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: const Text('Guardar y continuar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
