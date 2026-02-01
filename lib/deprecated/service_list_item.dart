// lib/features/owner/catalogues/domain/entities/service_category_entity.dart
// Deprecated: duplicate of domain entity and unused.
@Deprecated('Use lib/features/owner/catalogues/domain/entities/service_category_entity.dart instead.')

class ServiceCategoryEntity {
  final String id;
  final String code;
  final String name;

  const ServiceCategoryEntity({
    required this.id,
    required this.code,
    required this.name,
  });

  // Constantes para categorías comunes
  static const ServiceCategoryEntity haircuts = ServiceCategoryEntity(
    id: '1',
    code: 'haircuts',
    name: 'Cortes de Cabello',
  );

  static const ServiceCategoryEntity nails = ServiceCategoryEntity(
    id: '2',
    code: 'nails',
    name: 'Manicure y Pedicure',
  );

  static const ServiceCategoryEntity spa = ServiceCategoryEntity(
    id: '3',
    code: 'spa',
    name: 'Tratamientos Spa',
  );

  static const ServiceCategoryEntity makeup = ServiceCategoryEntity(
    id: '4',
    code: 'makeup',
    name: 'Maquillaje',
  );

  ServiceCategoryEntity copyWith({
    String? id,
    String? code,
    String? name,
  }) {
    return ServiceCategoryEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceCategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
