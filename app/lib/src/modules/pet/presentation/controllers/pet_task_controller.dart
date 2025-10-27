import 'dart:async';

import '../../domain/entities/pet_task_entity.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/watch_tasks_usecase.dart';
import '../stores/pet_task_store.dart';

class PetTaskController {
  final WatchTasksUseCase watchUseCase;
  final AddTaskUseCase addUseCase;
  final UpdateTaskUseCase updateUseCase;
  final DeleteTaskUseCase deleteUseCase;
  final PetTaskStore store;

  StreamSubscription<List<PetTaskEntity>>? _sub;

  PetTaskController(
    this.watchUseCase,
    this.addUseCase,
    this.updateUseCase,
    this.deleteUseCase,
    this.store,
  );

  void watchTasks(String petId) {
    _sub?.cancel();
    _sub = watchUseCase(petId).listen((list) => store.setTasks(list));
  }

  Future<PetTaskEntity> addTask(PetTaskEntity task) async {
    store.setLoading(true);
    try {
      final created = await addUseCase.call(task);
      return created;
    } finally {
      store.setLoading(false);
    }
  }

  Future<PetTaskEntity> updateTask(PetTaskEntity task) async {
    store.setLoading(true);
    try {
      final updated = await updateUseCase.call(task);
      return updated;
    } finally {
      store.setLoading(false);
    }
  }

  Future<void> deleteTask(String id) async {
    store.setLoading(true);
    try {
      await deleteUseCase.call(id);
    } finally {
      store.setLoading(false);
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }
}
