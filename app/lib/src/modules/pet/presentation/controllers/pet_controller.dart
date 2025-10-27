import 'dart:async';
import 'dart:io';

import '../../../core/presenter/stores/app_store.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/usecases/add_pet_usecase.dart';
import '../../domain/usecases/delete_pet_usecase.dart';
import '../../domain/usecases/update_pet_usecase.dart';
import '../../domain/usecases/upload_image_usecase.dart';
import '../../domain/usecases/watch_pets_usecase.dart';
import '../stores/pet_store.dart';
import 'pet_task_controller.dart';

class PetController {
  final WatchPetsUseCase watchUseCase;
  final AddPetUseCase addPetUseCase;
  final UpdatePetUseCase updatePetUseCase;
  final DeletePetUseCase deletePetUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final PetStore store;
  final AppStore appStore;
  final PetTaskController taskController;

  StreamSubscription<List<PetEntity>>? _sub;

  PetController(
    this.watchUseCase,
    this.addPetUseCase,
    this.updatePetUseCase,
    this.deletePetUseCase,
    this.uploadImageUseCase,
    this.store,
    this.taskController,
    this.appStore,
  );

  void watchPets() {
    _sub?.cancel();
    _sub = watchUseCase(appStore.user!.familyCode).listen((list) {
      store.setPets(list);
    });
  }

  Future<void> addPet(
    PetEntity pet, {
    required String familyCode,
    File? imageFile,
  }) async {
    store.setLoading(true);
    try {
      var photoUrl = pet.photoUrl;
      if (imageFile != null) {
        final filename =
            '${DateTime.now().millisecondsSinceEpoch}_${pet.name}.jpg';
        photoUrl = await uploadImageUseCase(imageFile, filename);
      }
      await addPetUseCase.call(
        PetEntity(
          familyCode: familyCode,
          id: pet.id,
          name: pet.name,
          specie: pet.specie,
          birthDate: pet.birthDate,
          weightKg: pet.weightKg,
          photoUrl: photoUrl,
          createdAt: pet.createdAt,
        ),
      );
    } catch (e) {
      rethrow;
    } finally {
      store.setLoading(false);
    }
  }

  Future<void> updatePet(PetEntity pet, {File? imageFile}) async {
    store.setLoading(true);
    try {
      var photoUrl = pet.photoUrl;
      if (imageFile != null) {
        final filename =
            '${DateTime.now().millisecondsSinceEpoch}_${pet.name}.jpg';
        photoUrl = await uploadImageUseCase.call(imageFile, filename);
      }
      await updatePetUseCase.call(
        PetEntity(
          id: pet.id,
          name: pet.name,
          specie: pet.specie,
          birthDate: pet.birthDate,
          weightKg: pet.weightKg,
          photoUrl: photoUrl,
          createdAt: pet.createdAt,
          familyCode: pet.familyCode,
        ),
      );
    } finally {
      store.setLoading(false);
    }
  }

  Future<void> deletePet(String id) async {
    store.setLoading(true);
    try {
      await deletePetUseCase.call(id);
    } finally {
      store.setLoading(false);
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }
}
