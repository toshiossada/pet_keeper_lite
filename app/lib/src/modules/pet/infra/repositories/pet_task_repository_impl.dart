import '../../domain/entities/pet_task_entity.dart';
import '../../domain/repositories/pet_task_repository.dart';
import '../datasources/firebase_pet_tasks_datasource.dart';
import '../models/pet_task_model.dart';

class PetTaskRepositoryImpl implements PetTaskRepository {
  final FirebasePetTasksDataSource datasource;
  PetTaskRepositoryImpl(this.datasource);

  @override
  Future<void> deleteTask(String id) => datasource.deleteTask(id);

  @override
  Future<PetTaskEntity> addTask(PetTaskEntity task) async {
    final created = await datasource.addTask(PetTaskModel.fromEntity(task));
    return created;
  }

  @override
  Future<PetTaskEntity> updateTask(PetTaskEntity task) async {
    final updated = await datasource.updateTask(PetTaskModel.fromEntity(task));
    return updated;
  }

  @override
  Stream<List<PetTaskEntity>> watchTasks(String petId) =>
      datasource.watchTasks(petId);
}
