class ServiceEntity {
  final String id;
  final String name;
  final int durationMin;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.durationMin,
  });

  /// Devuelve la duración como un objeto Duration
  Duration get duration => Duration(minutes: durationMin);

  /// Formatea la duración como texto (ej: "1h 30m" o "45m")
  String get durationLabel {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  ServiceEntity copyWith({
    String? id,
    String? name,
    int? durationMinutes,
  }) {
    return ServiceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      durationMin: durationMinutes ?? this.durationMin,
    );
  }
}
