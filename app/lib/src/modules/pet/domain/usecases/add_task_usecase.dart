import '../../domain/entities/pet_task_entity.dart';
import '../repositories/pet_task_repository.dart';

class AddTaskUseCase {
  final PetTaskRepository repository;
  AddTaskUseCase(this.repository);

  Future<PetTaskEntity> call(PetTaskEntity task) => repository.addTask(task);
}
