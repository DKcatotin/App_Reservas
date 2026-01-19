// lib/features/owner/catalogues/presentation/widgets/staff_selector.dart

import 'package:flutter/material.dart';
import '../../data/models/staff.dart'; // ✅ USAR Staff, no StaffEntity

/// Widget reutilizable para seleccionar staff
class StaffSelector extends StatelessWidget {
  final List<Staff> staffList; // ✅ List<Staff>
  final String? selectedStaffId;
  final Function(String?) onChanged;
  final bool allowNull;

  const StaffSelector({
    super.key,
    required this.staffList,
    required this.selectedStaffId,
    required this.onChanged,
    this.allowNull = true,
  });

  @override
  Widget build(BuildContext context) {
    if (staffList.isEmpty) {
      return _buildLoadingState();
    }

    // Eliminar duplicados
    final uniqueStaffList = <String, Staff>{};
    for (var staff in staffList) {
      uniqueStaffList[staff.id] = staff;
    }
    final cleanStaffList = uniqueStaffList.values.toList();

    // Validar que el valor seleccionado exista
    final validValue = cleanStaffList.any((s) => s.id == selectedStaffId)
        ? selectedStaffId
        : null;

    return DropdownButtonFormField<String>(
      value: validValue,
      decoration: InputDecoration(
        hintText: 'Seleccionar empleado',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF3B82F6).withValues(alpha: 0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: const Icon(
          Icons.person_outline_rounded,
          color: Color(0xFF3B82F6),
        ),
      ),
      items: [
        if (allowNull)
          const DropdownMenuItem<String>(
            value: null,
            child: Text(
              'Sin asignar',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ),
        ...cleanStaffList.map(
          (staff) => DropdownMenuItem<String>(
            value: staff.id,
            child: Text(staff.displayName),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text(
            'Cargando empleados...',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
