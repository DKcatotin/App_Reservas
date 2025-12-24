import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final DateTime startAt;
  final String customerName;
  final String serviceName;
  final String status; // pending | confirmed | done | canceled

  const Appointment({
    required this.id,
    required this.startAt,
    required this.customerName,
    required this.serviceName,
    required this.status,
  });

  @override
  List<Object?> get props => [id, startAt, customerName, serviceName, status];
}
