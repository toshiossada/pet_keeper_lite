import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pet_task_model.dart';

class FirebasePetTasksDataSource {
  final _col = FirebaseFirestore.instance.collection('pet_tasks');

  Stream<List<PetTaskModel>> watchTasks(String petId) {
    final q = _col
        .where('petId', isEqualTo: petId)
        .orderBy('createdAt', descending: true);
    return q.snapshots().map(
      (s) => s.docs.map((d) => PetTaskModel.fromJson(d.id, d.data())).toList(),
    );
  }

  Future<PetTaskModel> addTask(PetTaskModel task) async {
    final data = task.toJson();
    final ref = await _col.add(data);
    final created = await ref.get();
    return PetTaskModel.fromJson(created.id, created.data()!);
  }

  Future<PetTaskModel> updateTask(PetTaskModel task) async {
    final data = task.toJson();
    await _col.doc(task.id).set(data, SetOptions(merge: true));
    final updated = await _col.doc(task.id).get();
    return PetTaskModel.fromJson(updated.id, updated.data()!);
  }

  Future<void> deleteTask(String id) async {
    await _col.doc(id).delete();
  }
}
