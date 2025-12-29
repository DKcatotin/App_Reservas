import 'package:agenda_app/features/owner/appointments/presentation/pages/appointment_detail_page.dart';
import 'package:flutter/material.dart';
import '../../data/models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment a;
  const AppointmentCard({super.key, required this.a});

  // Usa el label del status para mapear colores
  Color _statusColor(String statusLabel) {
    switch (statusLabel) {
      case 'Pendiente':
        return Colors.orange;
      case 'Confirmada':
        return Colors.blue;
      case 'Terminada':
        return Colors.green;
      case 'Cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(a.startAt).format(context);

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _statusColor(a.status.label)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text('${a.customer.name} • ${a.services.first.name}'),
        subtitle: Text('Hora: $time'),
        trailing: Chip(label: Text(a.status.label)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentDetailPage(appointment: a),
            ),
          );
        },
      ),
    );
  }
}
