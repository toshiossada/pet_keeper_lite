import '../../domain/entities/pet_task_entity.dart';
import '../repositories/pet_task_repository.dart';

class UpdateTaskUseCase {
  final PetTaskRepository repository;
  UpdateTaskUseCase(this.repository);

  Future<PetTaskEntity> call(PetTaskEntity task) => repository.updateTask(task);
}
