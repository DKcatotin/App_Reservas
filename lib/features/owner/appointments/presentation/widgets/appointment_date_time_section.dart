// lib/features/owner/appointments/presentation/widgets/appointment_date_time_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget específico de appointments para mostrar y editar fecha/hora de la cita
class AppointmentDateTimeSection extends StatelessWidget {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isEditing;
  final VoidCallback? onDateTap;
  final VoidCallback? onStartTimeTap;

  const AppointmentDateTimeSection({
    super.key, // ✅ AGREGADO: key parameter
    required this.date, // ✅ AGREGADO: required
    required this.startTime, // ✅ AGREGADO: required
    required this.endTime, // ✅ AGREGADO: required
    required this.isEditing, // ✅ AGREGADO: required
    this.onDateTap,
    this.onStartTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE dd MMM yyyy', 'es');

    return Column(
      children: [
        InkWell(
          onTap: isEditing ? onDateTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isEditing
                  ? const Color(0xFF7C3AED).withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isEditing
                  ? Border.all(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📅 FECHA (ARRIBA)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fecha',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormatter.format(date),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isEditing)
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF7C3AED),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                
                /// ⏰ HORAS (ABAJO)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF7C3AED).withValues(alpha: 0.1),
                        const Color(0xFF9333EA).withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// INICIO - EDITABLE
                      InkWell(
                        onTap: isEditing ? onStartTimeTap : null,
                        borderRadius: BorderRadius.circular(8),
                        child: _TimeBlock(
                          label: 'Inicio',
                          time: startTime.format(context),
                          isEditable: isEditing,
                        ),
                      ),
                      
                      Container(
                        height: 40,
                        width: 2,
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                      ),
                      
                      /// FIN - CALCULADO (NO EDITABLE)
                      _TimeBlock(
                        label: 'Fin',
                        time: endTime.format(context),
                        isEditable: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget interno para mostrar bloques de tiempo
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
