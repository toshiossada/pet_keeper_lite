import '../repositories/pet_task_repository.dart';

class DeleteTaskUseCase {
  final PetTaskRepository repository;
  DeleteTaskUseCase(this.repository);

  Future<void> call(String id) => repository.deleteTask(id);
}
