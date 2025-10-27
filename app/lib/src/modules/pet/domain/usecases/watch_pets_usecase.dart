import '../entities/pet_entity.dart';
import '../repositories/pet_repository.dart';

class WatchPetsUseCase {
  final PetRepository repository;
  WatchPetsUseCase(this.repository);

  Stream<List<PetEntity>> call(String? familyCode) =>
      repository.watchPets(familyCode);
}
