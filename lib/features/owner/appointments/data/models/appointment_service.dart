class AppointmentService {
  final String id;
  final String name;
  final int durationMinutes;

  AppointmentService({
    required this.id,
    required this.name,
    required this.durationMinutes,
  });

  factory AppointmentService.fromJson(Map<String, dynamic> json) {
    return AppointmentService(
      id: json['id'] as String,
      name: json['name'] as String,
      durationMinutes: json['duration_minutes'] as int,
    );
  }

  /// Devuelve la duración como un objeto Duration
  Duration get duration => Duration(minutes: durationMinutes);

  /// Si quieres mostrarlo como texto (ej: "1h 30m")
  String get durationLabel {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
