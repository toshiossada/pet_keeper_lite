class PetTaskEntity {
  final String id;
  final String petId;
  final String title;
  final DateTime? date;
  final bool done;
  final DateTime? createdAt;

  PetTaskEntity({
    required this.id,
    required this.petId,
    required this.title,
    this.date,
    this.done = false,
    this.createdAt,
  });

  PetTaskEntity copyWith({
    String? id,
    String? petId,
    String? title,
    DateTime? date,
    bool? done,
    DateTime? createdAt,
  }) {
    return PetTaskEntity(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      title: title ?? this.title,
      date: date ?? this.date,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
