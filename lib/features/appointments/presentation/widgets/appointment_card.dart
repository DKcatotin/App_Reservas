import 'package:flutter/material.dart';
import '../../data/models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment a;
  const AppointmentCard({super.key, required this.a});

  Color _statusColor(String status) {
    return switch (status) {
      'pending' => Colors.orange,
      'confirmed' => Colors.blue,
      'done' => Colors.green,
      'canceled' => Colors.red,
      _ => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(a.startAt).format(context);

    return Card(
      child: ListTile(
        title: Text('${a.customerName} • ${a.serviceName}'),
        subtitle: Text('Hora: $time'),
        trailing: Chip(
          label: Text(a.status),
          side: BorderSide(color: _statusColor(a.status)),
        ),
      ),
    );
  }
}
