class AppointmentService {
  final String id;
  final String appointmentId;
  final String serviceId;
  final int durationMin;
  final double price;
  
  // ✅ AGREGAR: Campos del servicio obtenidos por JOIN
  final String? serviceName;
  final String? branchId;
  final String? categoryId;
  final String? description;
  final double? basePrice;
  final bool? enabled;

  AppointmentService({
    required this.id,
    required this.appointmentId,
    required this.serviceId,
    required this.durationMin,
    required this.price,
    this.serviceName,
    this.branchId,
    this.categoryId,
    this.description,
    this.basePrice,
    this.enabled,
  });

  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    return AppointmentService(
      id: json['id'] as String? ?? '',
      appointmentId: json['appointment_id'] as String? ?? '',
      serviceId: json['service_id'] as String? ?? '',
      durationMin: (json['duration_min'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      // Campos del JOIN con services
      serviceName: json['service']?['name'] as String? ?? json['name'] as String?,
      branchId: json['service']?['branch_id'] as String?,
      categoryId: json['service']?['category_id'] as String?,
      description: json['service']?['description'] as String?,
      basePrice: json['service']?['base_price'] != null 
          ? (json['service']?['base_price'] as num).toDouble() 
          : null,
      enabled: json['service']?['enabled'] as bool?,
    );
  }

  Duration get duration => Duration(minutes: durationMin);

  String get durationLabel {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_id': appointmentId,
      'service_id': serviceId,
      'duration_min': durationMin,
      'price': price,
    };
  }
}
