class AppointmentService {
  final String id;
  final String appointmentId;
  final String serviceId;
  final int durationMin;
  final double price;
  
  // Datos del servicio relacionado (pueden venir del backend)
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

  /// ✅ ACTUALIZADO: Parsear desde la estructura anidada del backend
  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    // El backend puede devolver la estructura así:
    // {
    //   "id": "uuid",
    //   "appointmentId": "uuid",
    //   "serviceId": "uuid",
    //   "durationMin": 60,
    //   "price": "18.00",
    //   "service": {              ← ANIDADO
    //     "id": "uuid",
    //     "name": "Pedicure",
    //     "branchId": "uuid",
    //     "categoryId": "uuid",
    //     "description": "...",
    //     "durationMin": 60,
    //     "basePrice": "18.00",
    //     "enabled": true
    //   }
    // }

    final serviceData = json['service'] as Map<String, dynamic>?;

    return AppointmentService(
      id: json['id'] as String,
      appointmentId: json['appointmentId'] as String,
      serviceId: json['serviceId'] as String,
      durationMin: json['durationMin'] as int,
      price: double.parse(json['price'].toString()),
      
      // ✅ Si viene el objeto "service" anidado, extraer sus datos
      serviceName: serviceData?['name'] as String?,
      branchId: serviceData?['branchId'] as String?,
      categoryId: serviceData?['categoryId'] as String?,
      description: serviceData?['description'] as String?,
      basePrice: serviceData != null 
          ? double.parse(serviceData['basePrice'].toString())
          : null,
      enabled: serviceData?['enabled'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'serviceId': serviceId,
      'durationMin': durationMin,
      'price': price,
      'serviceName': serviceName,
      'branchId': branchId,
      'categoryId': categoryId,
      'description': description,
      'basePrice': basePrice,
      'enabled': enabled,
    };
  }
}
