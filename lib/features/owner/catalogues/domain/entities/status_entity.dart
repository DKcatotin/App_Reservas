class StatusEntity {
  final String id;  // ✅ UUID en lugar de int
  final String code;
  final String name;

  const StatusEntity({
    required this.id,
    required this.code,
    required this.name,
  });

  // ✅ Constantes (IDs vacíos porque se cargan dinámicamente)
  static const StatusEntity pending = StatusEntity(
    id: '',  // Se llena desde el backend
    code: 'PENDING',
    name: 'Pendiente',
  );

  static const StatusEntity confirmed = StatusEntity(
    id: '',
    code: 'CONFIRMED',
    name: 'Confirmada',
  );

  static const StatusEntity completed = StatusEntity(
    id: '',
    code: 'COMPLETED',
    name: 'Completada',
  );

  static const StatusEntity cancelled = StatusEntity(
    id: '',
    code: 'CANCELLED',
    name: 'Cancelada',
  );

  StatusEntity copyWith({
    String? id,
    String? code,
    String? name,
  }) {
    return StatusEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }
}