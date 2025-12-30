import 'package:agenda_app/features/owner/appointments/data/models/appointment.dart';
import 'package:agenda_app/features/owner/appointments/data/models/appointment_service.dart';
import 'package:agenda_app/features/owner/appointments/data/models/source.dart';
import 'package:agenda_app/features/owner/appointments/data/models/staff.dart';
import 'package:agenda_app/features/owner/appointments/data/models/status.dart';
import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../appointments/data/models/customer.dart';
import '../../../catalogues/data/sources/catalogues_json_datasource.dart';
import '../../../catalogues/data/models/service.dart';

class AppointmentFormPage extends StatefulWidget {
  final AppointmentsRepository repo;

  const AppointmentFormPage({
    super.key,
    required this.repo,
  });

  @override
  State<AppointmentFormPage> createState() => _AppointmentFormPageState();
}

class _AppointmentFormPageState extends State<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _datasource = CataloguesJsonDatasource();

  List<Customer> _customers = [];
  List<Service> _services = [];

  Customer? _selectedCustomer;
  List<Service> _selectedServices = [];
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedSource = 'whatsapp';

  bool _isLoading = true;
  bool _isSaving = false;

  final List<Map<String, dynamic>> _sources = [
    {'id': 'whatsapp', 'label': 'WhatsApp', 'icon': Icons.chat},
    {'id': 'llamada', 'label': 'Llamada', 'icon': Icons.phone},
    {'id': 'web', 'label': 'Web', 'icon': Icons.language},
    {'id': 'presencial', 'label': 'Presencial', 'icon': Icons.store},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final customers = await _datasource.getCustomers();
      final services = await _datasource.getServices();

      setState(() {
        _customers = customers;
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5CF6),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5CF6),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Staff _dummyStaff() {
    return Staff(
      id: 's1',
      name: 'Staff demo',
    );
  }

  int _calculateTotalMinutes() {
    return _selectedServices.fold(0, (sum, s) => sum + s.durationMinutes);
  }

  double _calculateTotalPrice() {
    return _selectedServices.fold(0.0, (sum, s) => sum + s.price);
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    final startAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final totalMinutes = _calculateTotalMinutes();

    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ownerId: 'owner1',
      branchId: 'branch1',
      customerId: _selectedCustomer!.id,
      staffId: 's1',
      startAt: startAt,
      endAt: startAt.add(Duration(minutes: totalMinutes)),
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      status: Status(code: 'pending', label: 'Pendiente'),
      source: Source(type: _selectedSource),
      customer: _selectedCustomer!,
      staff: _dummyStaff(),
      services: _selectedServices.map((s) {
        return AppointmentService(
          id: s.id,
          name: s.name,
          durationMinutes: s.durationMinutes,
        );
      }).toList(),
    );

    setState(() => _isSaving = true);

    await widget.repo.create(appointment);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nueva Cita'),
          backgroundColor: const Color(0xFF8B5CF6),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        title: const Text('Nueva Cita'),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              title: 'Cliente',
              icon: Icons.person,
              child: _buildCustomerSelector(),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Fecha y hora',
              icon: Icons.event,
              child: Row(
                children: [
                  Expanded(child: _buildDateButton()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTimeButton()),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Servicios',
              icon: Icons.spa,
              child: _buildServicesSelector(),
            ),
            if (_selectedServices.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildServicesSummary(),
            ],
            const SizedBox(height: 16),
            _buildSection(
              title: 'Fuente de la cita',
              icon: Icons.source,
              child: _buildSourceSelector(),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Notas (opcional)',
              icon: Icons.note,
              child: TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Preferencias, alergias, etc.',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check_circle),
                label: Text(
                  _isSaving ? 'Guardando...' : 'Crear Cita',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF8B5CF6)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildCustomerSelector() {
    return DropdownButtonFormField<Customer>(
      value: _selectedCustomer,
      decoration: const InputDecoration(
        hintText: 'Selecciona un cliente',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      items: _customers.map((c) {
        return DropdownMenuItem(
          value: c,
          child: Text('${c.name} - ${c.phone}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => _selectedCustomer = value);
      },
      validator: (value) {
        if (value == null) return 'Selecciona un cliente';
        return null;
      },
    );
  }

  Widget _buildDateButton() {
    return OutlinedButton.icon(
      onPressed: _selectDate,
      icon: const Icon(Icons.calendar_today),
      label: Text(
        DateFormat('dd MMM yyyy', 'es').format(_selectedDate),
        style: const TextStyle(fontSize: 16),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Color(0xFF8B5CF6)),
      ),
    );
  }

  Widget _buildTimeButton() {
    return OutlinedButton.icon(
      onPressed: _selectTime,
      icon: const Icon(Icons.access_time),
      label: Text(
        _selectedTime.format(context),
        style: const TextStyle(fontSize: 16),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Color(0xFF8B5CF6)),
      ),
    );
  }

  Widget _buildServicesSelector() {
    return Column(
      children: _services.map((s) {
        final isSelected = _selectedServices.contains(s);
        return CheckboxListTile(
          title: Text(s.name),
          subtitle: Text('${s.durationLabel} • \$${s.price.toStringAsFixed(2)}'),
          value: isSelected,
          onChanged: (checked) {
            setState(() {
              if (checked == true) {
                _selectedServices.add(s);
              } else {
                _selectedServices.remove(s);
              }
            });
          },
          activeColor: const Color(0xFF8B5CF6),
        );
      }).toList(),
    );
  }

  Widget _buildServicesSummary() {
    final totalMinutes = _calculateTotalMinutes();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    final durationText = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Duración total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(durationText),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Total a pagar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _sources.map((source) {
        final isSelected = _selectedSource == source['id'];
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                source['icon'] as IconData,
                size: 18,
                color: isSelected ? Colors.white : Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(source['label'] as String),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() => _selectedSource = source['id'] as String);
          },
          selectedColor: const Color(0xFF8B5CF6),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}