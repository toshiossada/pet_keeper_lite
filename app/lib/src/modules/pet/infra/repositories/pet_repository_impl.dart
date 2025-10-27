import 'dart:io';

import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pet_repository.dart';
import '../datasources/firebase_pets_datasource.dart';
import '../models/pet_model.dart';

class PetRepositoryImpl implements PetRepository {
  final FirebasePetsDataSource datasource;
  PetRepositoryImpl(this.datasource);

  @override
  Future<void> deletePet(String id) => datasource.deletePet(id);

  @override
  Future<PetEntity?> getPet(String id) => datasource.getPet(id);

  @override
  Future<PetEntity> addPet(PetEntity pet) async {
    final created = await datasource.addPet(PetModel.fromEntity(pet));
    return created;
  }

  @override
  Stream<List<PetEntity>> watchPets(String? familyCode) =>
      datasource.watchPets(familyCode);

  @override
  Future<PetEntity> updatePet(PetEntity pet) async {
    final updated = await datasource.updatePet(
      PetModel.fromEntity(pet),
    );
    return updated;
  }

  @override
  Future<String> uploadImage(File file, String filename) =>
      datasource.uploadImage(file, filename);
}
