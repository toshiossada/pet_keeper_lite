import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/pet_model.dart';

class FirebasePetsDataSource {
  final _col = FirebaseFirestore.instance.collection('pets');
  final _storage = FirebaseStorage.instance;

  Stream<List<PetModel>> watchPets(String? familyCode) {
    return _col
        .where('familyCode', isEqualTo: familyCode)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs.map((d) => PetModel.fromJson(d.id, d.data())).toList(),
        );
  }

  Future<PetModel?> getPet(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return PetModel.fromJson(doc.id, doc.data()!);
  }

  Future<PetModel> addPet(PetModel pet) async {
    final data = pet.toJson();
    final ref = await _col.add(data);
    final created = await ref.get();
    return PetModel.fromJson(created.id, created.data()!);
  }

  Future<PetModel> updatePet(PetModel pet) async {
    final data = pet.toJson();
    await _col.doc(pet.id).set(data, SetOptions(merge: true));
    final updated = await _col.doc(pet.id).get();
    return PetModel.fromJson(updated.id, updated.data()!);
  }

  Future<void> deletePet(String id) async {
    await _col.doc(id).delete();
  }

  Future<String> uploadImage(File file, String filename) async {
    try {
      final ref = _storage.ref().child('pet_photos/$filename');
      final task = await ref.putFile(file);
      return task.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }
}
