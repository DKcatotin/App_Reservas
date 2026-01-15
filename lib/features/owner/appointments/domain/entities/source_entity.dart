class SourceEntity {
  final int id; 
  final String code;
  final String name;

  const SourceEntity({
    required this.id,
    required this.code,
    required this.name,
  });

  // Constantes para los sources comunes (según tu BD)
  static const SourceEntity web = SourceEntity(
    id: 1,
    code: 'web',
    name: 'Web',
  );

  static const SourceEntity whatsapp = SourceEntity(
    id: 2,
    code: 'whatsapp',
    name: 'WhatsApp',
  );

  static const SourceEntity call = SourceEntity(
    id: 3,
    code: 'call',
    name: 'Llamada',
  );

  static const SourceEntity inPerson = SourceEntity(
    id:4,
    code: 'in_person',
    name: 'Presencial',
  );

  SourceEntity copyWith({
    String? code,
    String? name,
  }) {
    return SourceEntity(
      id: id,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }
}
