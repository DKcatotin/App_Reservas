import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/appointment.dart';

class AppointmentDetailPage extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailPage({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  bool _isEditing = false;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _selectedStatus;
  late List<dynamic> _selectedServices;
  late TextEditingController _notesController;
  late List<TextEditingController> _serviceControllers;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.appointment.startAt;
    _startTime = TimeOfDay.fromDateTime(widget.appointment.startAt);
    _endTime = TimeOfDay.fromDateTime(widget.appointment.endAt);
    _selectedStatus = widget.appointment.status.label;
    _selectedServices = List.from(widget.appointment.services);
    _notesController = TextEditingController(text: widget.appointment.notes ?? '');

    _serviceControllers = _selectedServices.map((s) {
      return TextEditingController(text: (s as dynamic).name);
    }).toList();
  }

  @override
  void dispose() {
    _notesController.dispose();
    for (var controller in _serviceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C3AED),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1F2937),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C3AED),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1F2937),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveChanges() {
    final newStartAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final newEndAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    for (int i = 0; i < _selectedServices.length; i++) {
      // Actualizar servicios según tu lógica
    }

    // TODO: Guardar cambios incluyendo las notas
    // String notesValue = _notesController.text.trim();
    // if (notesValue.isEmpty) notesValue = null;

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Cambios guardados exitosamente'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _selectedDate = widget.appointment.startAt;
      _startTime = TimeOfDay.fromDateTime(widget.appointment.startAt);
      _endTime = TimeOfDay.fromDateTime(widget.appointment.endAt);
      _selectedStatus = widget.appointment.status.label;
      _selectedServices = List.from(widget.appointment.services);
      _notesController.text = widget.appointment.notes ?? '';

      for (int i = 0; i < _serviceControllers.length; i++) {
        _serviceControllers[i].text = (_selectedServices[i] as dynamic).name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE dd MMM yyyy', 'es');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF7C3AED),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (_isEditing) ...[
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _cancelEdit,
                    tooltip: 'Cancelar',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, color: Colors.white),
                    onPressed: _saveChanges,
                    tooltip: 'Guardar',
                  ),
                ),
              ] else
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    tooltip: 'Editar',
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _isEditing ? 'Editar Cita' : 'Detalle de la Cita',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7C3AED),
                      Color(0xFF9333EA),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// CLIENTE
                  _ModernInfoCard(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                    ),
                    icon: Icons.person_rounded,
                    title: 'Cliente',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.appointment.customer.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.phone_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.appointment.customer.phone,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// FECHA Y HORA
                  _WhiteInfoCard(
                    icon: Icons.calendar_today_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    title: 'Fecha y Hora',
                    child: Column(
                      children: [
                        InkWell(
                          onTap: _isEditing ? () => _selectDate(context) : null,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _isEditing
                                  ? const Color(0xFF7C3AED).withOpacity(0.05)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: _isEditing
                                  ? Border.all(
                                      color: const Color(0xFF7C3AED)
                                          .withOpacity(0.3),
                                      width: 1,
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C3AED)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _isEditing
                                        ? Icons.edit_calendar
                                        : Icons.event,
                                    color: const Color(0xFF7C3AED),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Fecha',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        dateFormatter.format(_selectedDate),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_isEditing)
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF7C3AED),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF7C3AED).withOpacity(0.1),
                                const Color(0xFF9333EA).withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: _isEditing
                                    ? () => _selectTime(context, true)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                child: _TimeBlock(
                                  label: 'Inicio',
                                  time: _startTime.format(context),
                                  isEditable: _isEditing,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 2,
                                color: const Color(0xFF7C3AED).withOpacity(0.3),
                              ),
                              InkWell(
                                onTap: _isEditing
                                    ? () => _selectTime(context, false)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                child: _TimeBlock(
                                  label: 'Fin',
                                  time: _endTime.format(context),
                                  isEditable: _isEditing,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ESTADO
                  _WhiteInfoCard(
                    icon: Icons.info_rounded,
                    iconColor: _statusColor(_selectedStatus),
                    title: 'Estado',
                    child: _isEditing
                        ? DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xFF7C3AED).withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF7C3AED),
                                  width: 2,
                                ),
                              ),
                            ),
                            items: ['Confirmada', 'Pendiente', 'Cancelada']
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Row(
                                        children: [
                                          Icon(
                                            _statusIcon(status),
                                            color: _statusColor(status),
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(status),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedStatus = value;
                                });
                              }
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _statusColor(_selectedStatus),
                                  _statusColor(_selectedStatus)
                                      .withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: _statusColor(_selectedStatus)
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _statusIcon(_selectedStatus),
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedStatus,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),

                  const SizedBox(height: 16),

                  /// SERVICIOS
                  _WhiteInfoCard(
                    icon: Icons.spa_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    title: 'Servicios',
                    child: Column(
                      children:
                          List.generate(_selectedServices.length, (index) {
                        final s = _selectedServices[index];
                        final d = (s as dynamic).duration;
                        final hours = d.inHours;
                        final minutes = d.inMinutes.remainder(60);
                        final label =
                            hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF7C3AED).withOpacity(0.1),
                                const Color(0xFF9333EA).withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF7C3AED).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _isEditing
                                    ? TextField(
                                        controller: _serviceControllers[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1F2937),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Nombre del servicio',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: const Color(0xFF7C3AED)
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              color: const Color(0xFF7C3AED)
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF7C3AED),
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        (s as dynamic).name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// NOTAS
                  _WhiteInfoCard(
                    icon: Icons.notes_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Notas',
                    child: _isEditing
                        ? TextField(
                            controller: _notesController,
                            maxLines: 4,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1F2937),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Escribe notas adicionales sobre la cita...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color(0xFF7C3AED).withOpacity(0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: const Color(0xFF7C3AED).withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF7C3AED),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFF7C3AED).withOpacity(0.05),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          )
                        : (widget.appointment.notes == null || 
                           widget.appointment.notes!.isEmpty)
                            ? Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'No hay notas para esta cita',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFF59E0B).withOpacity(0.1),
                                      const Color(0xFFF59E0B).withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFF59E0B).withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  widget.appointment.notes!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1F2937),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmada':
        return const Color(0xFF10B981);
      case 'pendiente':
        return const Color(0xFFF59E0B);
      case 'cancelada':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmada':
        return Icons.check_circle;
      case 'pendiente':
        return Icons.access_time;
      case 'cancelada':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}

class _ModernInfoCard extends StatelessWidget {
  final Gradient gradient;
  final IconData icon;
  final String title;
  final Widget child;

  const _ModernInfoCard({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _WhiteInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _WhiteInfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String label;
  final String time;
  final bool isEditable;

  const _TimeBlock({
    required this.label,
    required this.time,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7C3AED),
                ),
              ),
              if (isEditable) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.edit,
                  size: 16,
                  color: Color(0xFF7C3AED),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}