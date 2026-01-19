class StatusEntity {
  final int id;
  final String code;
  final String name;

  const StatusEntity({
    required this.id,
    required this.code,
    required this.name,
  });

  // Constantes para los estados comunes
  static const StatusEntity pending = StatusEntity(
    id: 0,
    code: 'pending',
    name: 'Pendiente',
  );

  static const StatusEntity confirmed = StatusEntity(
    id: 1,
    code: 'confirmed',
    name: 'Confirmada',
  );

  static const StatusEntity cancelled = StatusEntity(
    id: 2,
    code: 'cancelled',
    name: 'Cancelada',
  );

  static const StatusEntity completed = StatusEntity(
    id: 3,
    code: 'completed',
    name: 'Completada',
  );

  StatusEntity copyWith({
    int? id,  //  AGREGADO - faltaba el id
    String? code,
    String? name, //  CORREGIDO - debe ser 'name' no 'label'
  }) {
    return StatusEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name, // CORREGIDO
    );
  }
}
