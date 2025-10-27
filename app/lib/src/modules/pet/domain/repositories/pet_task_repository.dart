import '../entities/pet_task_entity.dart';

abstract class PetTaskRepository {
  Stream<List<PetTaskEntity>> watchTasks(String petId);
  Future<PetTaskEntity> addTask(PetTaskEntity task);
  Future<PetTaskEntity> updateTask(PetTaskEntity task);
  Future<void> deleteTask(String id);
}
