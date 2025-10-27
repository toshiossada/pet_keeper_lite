import 'dart:io';

import '../entities/pet_entity.dart';

abstract class PetRepository {
  Stream<List<PetEntity>> watchPets(String? familyCode);
  Future<PetEntity?> getPet(String id);
  Future<PetEntity> addPet(PetEntity pet);
  Future<PetEntity> updatePet(PetEntity pet);
  Future<void> deletePet(String id);
  Future<String> uploadImage(File file, String filename);
}
