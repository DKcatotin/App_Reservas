// lib/features/owner/appointments/presentation/widgets/appointment_notes_section.dart

import 'package:flutter/material.dart';

/// Widget que muestra y permite editar las notas de una cita
class AppointmentNotesSection extends StatelessWidget {
  final bool isEditing;
  final TextEditingController notesController;
  final String? currentNotes;

  const AppointmentNotesSection({
    super.key,
    required this.isEditing,
    required this.notesController,
    this.currentNotes,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return _buildEditableNotes();
    }

    // Vista de solo lectura
    if (currentNotes == null || currentNotes!.isEmpty) {
      return _buildEmptyNotes();
    }

    return _buildDisplayNotes();
  }

  /// Campo editable de notas
  Widget _buildEditableNotes() {
    return TextField(
      controller: notesController,
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
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
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
        filled: true,
        fillColor: const Color(0xFF7C3AED).withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  /// Vista cuando no hay notas
  Widget _buildEmptyNotes() {
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
    );
  }

  /// Vista de solo lectura con notas
  Widget _buildDisplayNotes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF59E0B).withValues(alpha: 0.1),
            const Color(0xFFF59E0B).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        currentNotes!,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF1F2937),
          height: 1.5,
        ),
      ),
    );
  }
}
