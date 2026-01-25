import 'package:agenda_app/features/owner/appointments/data/repositories/appointments_repository_impl.dart';
import 'package:agenda_app/features/owner/appointments/domain/entities/appointment_entity.dart';
import 'package:agenda_app/features/owner/appointments/presentation/pages/appointments/appointment_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity a;
  final AppointmentsRepositoryImpl repository;
  final Future<void> Function(AppointmentEntity)? onAppointmentUpdated;
  final Future<void> Function(String)? onAppointmentDeleted;

  const AppointmentCard({
    super.key,
    required this.a,
    required this.repository,
    this.onAppointmentUpdated,
    this.onAppointmentDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentDetailPage(
                appointment: a,
                repository: repository,
                onAppointmentUpdated: onAppointmentUpdated,
                onAppointmentDeleted: onAppointmentDeleted,
              ),
            ),
          );

          if (result != null) {
            if (result is AppointmentEntity && onAppointmentUpdated != null) {
              await onAppointmentUpdated!(result);
            } else if (result is bool && result == true && onAppointmentDeleted != null) {
              // Eliminada - ya se manejó
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HORA
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 18,
                    color: _getStatusColor(a.status.code),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(a.startAt),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 12),

              /// CLIENTE - ✅ CORRECCIÓN AQUÍ
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Usar customer.fullName en lugar de a.customer.fullName directamente
                        Text(
                          a.customer.fullName ?? 'Sin nombre',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // ✅ Usar customer.phone en lugar de a.customer.phone directamente
                        Text(
                          a.customer.phone ?? 'Sin teléfono',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// SERVICIOS - Mostrar solo si existen
              if (a.services.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: a.services.map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${s.name} (${s.durationMin}m)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                // ✅ Mostrar mensaje si no hay servicios
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 14, color: Colors.orange[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Sin servicios asignados',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              /// STAFF (si existe)
              if (a.staff != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.face,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Atendido por: ${a.staff!.displayName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],

              /// NOTAS (si existen)
              if (a.notes != null && a.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.note,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          a.notes!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(a.status.code).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(a.status.code),
          width: 1,
        ),
      ),
      child: Text(
        a.status.name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _getStatusColor(a.status.code),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  Color _getStatusColor(String statusCode) {
    switch (statusCode.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}