import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/customer_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:agenda_app/features/owner/appointments/domain/inputs/create_appointement_input.dart';
import 'package:agenda_app/features/owner/appointments/presentation/providers/appointment_form_provider.dart';
import 'package:agenda_app/features/owner/appointments/presentation/providers/customer_provider.dart';
import 'package:agenda_app/features/owner/catalogues/domain/entities/service_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppointmentFormPage extends ConsumerStatefulWidget {
  const AppointmentFormPage({super.key});

  @override
  ConsumerState<AppointmentFormPage> createState() =>
      _AppointmentFormPageState();
}

class _AppointmentFormPageState extends ConsumerState<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  final List<ServiceEntity> _selectedServices = [];

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  SourceEntity? _selectedSource;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Cargar servicios y sources al abrir la página
    Future.microtask(() {
      ref.read(appointmentFormProvider).loadData();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Guardar la cita
  Future<void> _saveAppointment() async {
    if (_isSaving) return;

    final formProvider = ref.read(appointmentFormProvider);
    final customerState = ref.read(customerProvider);

    // Validaciones
    if (customerState.customer == null) {
      _showError('Debe seleccionar un cliente');
      return;
    }

    if (_selectedServices.isEmpty) {
      _showError('Debe seleccionar al menos un servicio');
      return;
    }

    if (_selectedSource == null) {
      _showError('Debe seleccionar una fuente de cita');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final startAt = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Calcular endAt basado en la duración total de los servicios
      final totalDurationMin =
          _selectedServices.fold<int>(0, (sum, service) => sum + service.durationMin);
      final endAt = startAt.add(Duration(minutes: totalDurationMin));

      final customer = customerState.customer!;

      final input = CreateAppointmentInput(
  customerId: customer.id,
  customer: CustomerEntity(
    id: customer.id,
    userId: customer.userId,
    referredBy: customer.referredBy,
    taxIdentification: customer.taxIdentification,
    taxName: customer.taxName,
    fullName: customer.fullName,
    phone: customer.phone,
    email: customer.email,
    allergies: customer.allergies,
  ),
  startAt: startAt,
  // ❌ REMOVER endAt - se calcula automático en el use case
  services: _selectedServices,  // ❌ REMOVER .toList() innecesario
  source: _selectedSource!,  // ✅ Ya es SourceEntity
  notes: _notesController.text,
);

      await formProvider.createAppointment(input);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Cita creada exitosamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      context.pop(true);
    } catch (e) {
      _showError('Error al crear la cita: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(appointmentFormProvider);
    final customerState = ref.watch(customerProvider);

    if (formState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (formState.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nueva Cita')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error al cargar datos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(formState.errorMessage!),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  formState.loadData();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Cita'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Cliente
            _buildClientInfo(customerState),
            const SizedBox(height: 16),

            // Fecha y hora
            _buildDateTimeSelector(),
            const SizedBox(height: 16),

            // Servicios
            _buildServicesSelector(formState.services),
            const SizedBox(height: 16),

            // Fuente de cita
            _buildSourceSelector(formState.sources),
            const SizedBox(height: 16),

            // Notas
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notas',
                border: OutlineInputBorder(),
                hintText: 'Ej: Cliente nuevo, preferencias especiales...',
              ),
            ),
            const SizedBox(height: 24),

            // Botón guardar
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveAppointment,
              icon: _isSaving ? null : const Icon(Icons.check),
              label: Text(_isSaving ? 'Guardando...' : 'Crear Cita'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Widget: Información del cliente
  Widget _buildClientInfo(CustomerState state) {
    if (state.customer == null) {
      return OutlinedButton.icon(
        onPressed: () => context.push('/owner/appointments/cliente/buscar'),
        icon: const Icon(Icons.person_search),
        label: const Text('Buscar o crear cliente'),
      );
    }

    return Card(
      color: Colors.green[50],
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(state.customer!.fullName ?? 'Sin nombre'),
        subtitle: Text(state.customer!.phone ?? 'Sin teléfono'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () =>
              context.push('/owner/appointments/cliente/buscar'),
        ),
      ),
    );
  }

  /// Widget: Selector de fecha y hora
  Widget _buildDateTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha y Hora',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    locale: const Locale('es'),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null) {
                    setState(() => _selectedTime = picked);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 8),
                    Text(_selectedTime.format(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Widget: Selector de servicios
  Widget _buildServicesSelector(List<ServiceEntity> services) {
    if (services.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'No hay servicios disponibles',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Servicios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...services.map((service) {
          final isSelected =
              _selectedServices.any((s) => s.id == service.id);

          return CheckboxListTile(
            title: Text(service.name),
            subtitle: Text(
              '${service.durationMin} min • \$${service.basePrice.toStringAsFixed(2)}',
            ),
            value: isSelected,
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _selectedServices.add(service);
                } else {
                  _selectedServices.removeWhere((s) => s.id == service.id);
                }
              });
            },
          );
        }).toList(),
      ],
    );
  }

  /// Widget: Selector de fuente de cita
 Widget _buildSourceSelector(List<SourceEntity> sources) {
  if (sources.isEmpty) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'No hay fuentes disponibles',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Fuente de Cita',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...sources.map((source) {
        final isSelected = _selectedSource?.id == source.id;
        
        return ListTile(
          leading: Radio<String>(
            value: source.id,
            groupValue: _selectedSource?.id,
            onChanged: (value) {
              setState(() => _selectedSource = source);
            },
          ),
          title: Text(source.name),
          subtitle: Text(source.description ?? ''),
          onTap: () {
            setState(() => _selectedSource = source);
          },
        );
      }),
    ],
  );
}

  /// Mostrar error
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
