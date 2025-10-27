import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/pet_task_entity.dart';

class PetTaskModel extends PetTaskEntity {
  PetTaskModel({
    required super.id,
    required super.petId,
    required super.title,
    super.date,
    super.done,
    super.createdAt,
  });

  factory PetTaskModel.fromJson(String id, Map<String, dynamic> json) {
    final ts = json['date'] as Timestamp?;
    final created = json['createdAt'] as Timestamp?;
    return PetTaskModel(
      id: id,
      petId: json['petId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: ts?.toDate(),
      done: json['done'] as bool? ?? false,
      createdAt: created?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'petId': petId,
    'title': title,
    'date': date == null ? null : Timestamp.fromDate(date!),
    'done': done,
    'createdAt': createdAt == null
        ? FieldValue.serverTimestamp()
        : Timestamp.fromDate(createdAt!),
  };

  factory PetTaskModel.fromEntity(PetTaskEntity e) => PetTaskModel(
    id: e.id,
    petId: e.petId,
    title: e.title,
    date: e.date,
    done: e.done,
    createdAt: e.createdAt,
  );
}
