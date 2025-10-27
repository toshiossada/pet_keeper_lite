// ignore_for_file: public_member_api_docs, sort_constructors_first
class PetEntity {
  final String id;
  final String name;
  final String familyCode;
  final String specie;
  final DateTime? birthDate;
  final double weightKg;
  final String photoUrl;
  final DateTime? createdAt;

  PetEntity({
    required this.id,
    required this.name,
    required this.specie,
    required this.weightKg,
    required this.photoUrl,
    required this.familyCode,
    this.birthDate,
    this.createdAt,
  });

  PetEntity copyWith({
    String? id,
    String? name,
    String? familyCode,
    String? specie,
    DateTime? birthDate,
    double? weightKg,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return PetEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      familyCode: familyCode ?? this.familyCode,
      specie: specie ?? this.specie,
      birthDate: birthDate ?? this.birthDate,
      weightKg: weightKg ?? this.weightKg,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
