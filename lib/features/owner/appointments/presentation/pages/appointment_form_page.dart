import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository.dart';
import 'package:agenda_app/features/owner/appointments/domain/create_appointement_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../catalogues/data/models/service.dart';
import '../../../catalogues/data/sources/catalogues_json_datasource.dart';

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
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  
  final _datasource = CataloguesJsonDatasource();

  List<Service> _services = [];
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
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final services = await _datasource.getServices();
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar datos')),
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
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un servicio')),
      );
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

      final input = CreateAppointmentInput(
        customerName: _customerNameController.text.trim(),
        customerPhone: _customerPhoneController.text.trim(),
        startAt: startAt,
        services: List<Service>.from(_selectedServices),
        source: _selectedSource,
        notes: _notesController.text, // el repo hace trim y null-safe
      );

      await widget.repo.createFromInput(input);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear la cita')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Cita')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              title: 'Cliente',
              icon: Icons.person,
              child: Column(
                children: [
                  TextFormField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del cliente',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _customerPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Campo requerido' : null,
                  ),
                ],
              ),
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
            ElevatedButton(
              onPressed: _isSaving ? null : _saveAppointment,
              child: Text(_isSaving ? 'Guardando...' : 'Crear Cita'),
            ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildDateButton() {
    return OutlinedButton(
      onPressed: _selectDate,
      child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
    );
  }

  Widget _buildTimeButton() {
    return OutlinedButton(
      onPressed: _selectTime,
      child: Text(_selectedTime.format(context)),
    );
  }

  Widget _buildServicesSelector() {
    return Column(
      children: _services.map((s) {
        return CheckboxListTile(
          title: Text(s.name),
          subtitle: Text('${s.durationLabel} • \$${s.price}'),
          value: _selectedServices.contains(s),
          onChanged: (checked) {
            setState(() {
              checked == true ? _selectedServices.add(s) : _selectedServices.remove(s);
            });
          },
        );
      }).toList(),
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
          onSelected: (_) => setState(() => _selectedSource = source['id'] as String),
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
