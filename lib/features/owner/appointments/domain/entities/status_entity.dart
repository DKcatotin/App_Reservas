class StatusEntity {
  final String code;
  final String label;

  const StatusEntity({
    required this.code,
    required this.label,
  });

  // Constantes para los estados comunes
  static const StatusEntity pending = StatusEntity(
    code: 'pending',
    label: 'Pendiente',
  );

  static const StatusEntity confirmed = StatusEntity(
    code: 'confirmed',
    label: 'Confirmada',
  );

  static const StatusEntity cancelled = StatusEntity(
    code: 'cancelled',
    label: 'Cancelada',
  );

  static const StatusEntity completed = StatusEntity(
    code: 'completed',
    label: 'Completada',
  );

  StatusEntity copyWith({
    String? code,
    String? label,
  }) {
    return StatusEntity(
      code: code ?? this.code,
      label: label ?? this.label,
    );
  }
}
