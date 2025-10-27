import '../../domain/entities/pet_task_entity.dart';
import '../repositories/pet_task_repository.dart';

class WatchTasksUseCase {
  final PetTaskRepository repository;
  WatchTasksUseCase(this.repository);

  Stream<List<PetTaskEntity>> call(String petId) =>
      repository.watchTasks(petId);
}
