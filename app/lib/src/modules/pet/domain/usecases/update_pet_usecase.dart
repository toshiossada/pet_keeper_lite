import '../entities/pet_entity.dart';
import '../repositories/pet_repository.dart';

class UpdatePetUseCase {
  final PetRepository repository;
  UpdatePetUseCase(this.repository);

  Future<PetEntity> call(PetEntity pet) => repository.updatePet(pet);
}
