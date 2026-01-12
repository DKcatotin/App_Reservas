class SourceEntity {
  final String code;
  final String name;

  const SourceEntity({
    required this.code,
    required this.name,
  });

  // Constantes para los sources comunes (según tu BD)
  static const SourceEntity web = SourceEntity(
    code: 'web',
    name: 'Web',
  );

  static const SourceEntity whatsapp = SourceEntity(
    code: 'whatsapp',
    name: 'WhatsApp',
  );

  static const SourceEntity call = SourceEntity(
    code: 'call',
    name: 'Llamada',
  );

  static const SourceEntity inPerson = SourceEntity(
    code: 'in_person',
    name: 'Presencial',
  );

  SourceEntity copyWith({
    String? code,
    String? name,
  }) {
    return SourceEntity(
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }
}
