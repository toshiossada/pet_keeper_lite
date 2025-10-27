import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/pet_entity.dart';

class PetModel extends PetEntity {
  PetModel({
    required super.id,
    required super.name,
    required super.specie,
    required super.weightKg,
    required super.photoUrl,
    required super.familyCode,
    super.birthDate,
    super.createdAt,
  });

  factory PetModel.fromEntity(PetEntity pet) => PetModel(
    id: pet.id,
    name: pet.name,
    specie: pet.specie,
    birthDate: pet.birthDate,
    weightKg: pet.weightKg,
    photoUrl: pet.photoUrl,
    familyCode: pet.familyCode,
    createdAt: pet.createdAt,
  );

  factory PetModel.fromJson(String id, Map<String, dynamic> json) => PetModel(
    id: id,
    name: json['name'] ?? '',
    specie: json['specie'] ?? '',
    birthDate: json['birthDate'] != null
        ? (json['birthDate'] as Timestamp).toDate()
        : null,
    weightKg: (json['weightKg'] ?? 0).toDouble(),
    photoUrl: json['photoUrl'] ?? '',
    familyCode: json['familyCode'] ?? '',
    createdAt: json['createdAt'] != null
        ? (json['createdAt'] as Timestamp).toDate()
        : null,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'specie': specie,
    'birthDate': birthDate,
    'weightKg': weightKg,
    'photoUrl': photoUrl,
    'familyCode': familyCode,
    'createdAt': createdAt ?? FieldValue.serverTimestamp(),
  };
}
