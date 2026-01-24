// lib/features/owner/appointments/presentation/widgets/appointment_status_selector.dart

import 'package:flutter/material.dart';

/// Widget específico de appointments para seleccionar el estado de una cita
/// Estados: Confirmada, Pendiente, Cancelada
class AppointmentStatusSelector extends StatelessWidget {
  final String status;
  final bool isEditing;
  final Function(String)? onChanged;
  final List<String> availableStatuses;

  const AppointmentStatusSelector({
    super.key, 
    required this.status, 
    required this.isEditing, 
    this.onChanged,
    this.availableStatuses = const ['Confirmada', 'Pendiente', 'Cancelada'],
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditing) {
      return _buildStatusBadge(status);
    }

    return _buildStatusDropdown();
  }

  /// Dropdown para editar el estado
  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: status, 
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
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
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
      items: availableStatuses.map((s) {
        return DropdownMenuItem(
          value: s,
          child: Row(
            children: [
              Icon(
                _getStatusIcon(s),
                color: _getStatusColor(s),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(s),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        // manejo de nullable a string
        if (value != null && onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }

  /// Badge visual para mostrar el estado (modo solo lectura)
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(status),
            _getStatusColor(status).withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(status).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Obtener el color según el estado
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmada':
        return const Color(0xFF10B981); // Verde
      case 'pendiente':
        return const Color(0xFFF59E0B); // Amarillo
      case 'cancelada':
        return const Color(0xFFEF4444); // Rojo
      default:
        return const Color(0xFF6B7280); // Gris
    }
  }

  /// Obtener el icono según el estado
  IconData _getStatusIcon(String status) {
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
