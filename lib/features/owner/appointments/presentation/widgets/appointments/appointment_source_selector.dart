// lib/features/owner/appointments/presentation/widgets/appointment_source_selector.dart

import 'package:agenda_app/features/owner/appointments/domain/entities/source_entity.dart';
import 'package:flutter/material.dart';

/// Widget para seleccionar o visualizar la fuente de una cita
/// (Web, Teléfono, WhatsApp, Presencial, etc.)
class AppointmentSourceSelector extends StatelessWidget {
  final SourceEntity? currentSource;
  final List<SourceEntity> availableSources;
  final Function(SourceEntity?) onChanged;
  final bool isEditing;

  const AppointmentSourceSelector({
    super.key,
    required this.currentSource,
    required this.availableSources,
    required this.onChanged,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditing) {
      return _buildDisplayMode();
    }

    return _buildEditMode();
  }

  /// Modo visualización (solo lectura)
  Widget _buildDisplayMode() {
    if (currentSource == null) {
      return Container(
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
              Icons.help_outline,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Fuente no especificada',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getSourceColor(currentSource!.code),
            _getSourceColor(currentSource!.code).withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: _getSourceColor(currentSource!.code).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getSourceIcon(currentSource!.code),
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            currentSource!.name,
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

  /// Modo edición (dropdown)
  Widget _buildEditMode() {
    return DropdownButtonFormField<String>(
      value: currentSource?.code,
      decoration: InputDecoration(
        hintText: 'Seleccionar fuente',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7C3AED)),
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
        filled: true,
        fillColor: const Color(0xFF7C3AED).withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: Icon(
          Icons.source_outlined,
          color: const Color(0xFF7C3AED),
        ),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text(
            'Sin especificar',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
        ...availableSources.map(
          (source) => DropdownMenuItem<String>(
            value: source.code,
            child: Row(
              children: [
                Icon(
                  _getSourceIcon(source.code),
                  color: _getSourceColor(source.code),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(source.name),
              ],
            ),
          ),
        ),
      ],
      onChanged: (code) {
        if (code == null) {
          onChanged(null);
        } else {
          final source = availableSources.firstWhere(
            (s) => s.code == code,
            orElse: () => availableSources.first,
          );
          onChanged(source);
        }
      },
    );
  }

  /// Obtener color según el código de fuente
  Color _getSourceColor(String code) {
    switch (code.toLowerCase()) {
      case 'web':
        return const Color(0xFF3B82F6); // Azul
      case 'phone':
        return const Color(0xFF10B981); // Verde
      case 'whatsapp':
        return const Color(0xFF25D366); // Verde WhatsApp
      case 'walk_in':
      case 'presencial':
        return const Color(0xFFF59E0B); // Amarillo
      case 'referral':
        return const Color(0xFF8B5CF6); // Púrpura
      default:
        return const Color(0xFF6B7280); // Gris
    }
  }

  /// Obtener icono según el código de fuente
  IconData _getSourceIcon(String code) {
    switch (code.toLowerCase()) {
      case 'web':
        return Icons.language;
      case 'phone':
        return Icons.phone;
      case 'whatsapp':
        return Icons.chat;
      case 'walk_in':
      case 'presencial':
        return Icons.store;
      case 'referral':
        return Icons.people;
      default:
        return Icons.help_outline;
    }
  }
}
