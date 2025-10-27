import 'package:flutter_modular/flutter_modular.dart';

import '../core/core_module.dart';
import 'domain/repositories/pet_repository.dart';
import 'domain/repositories/pet_task_repository.dart';
import 'domain/usecases/add_pet_usecase.dart';
import 'domain/usecases/add_task_usecase.dart';
import 'domain/usecases/delete_pet_usecase.dart';
import 'domain/usecases/delete_task_usecase.dart';
import 'domain/usecases/update_pet_usecase.dart';
import 'domain/usecases/update_task_usecase.dart';
import 'domain/usecases/upload_image_usecase.dart';
import 'domain/usecases/watch_pets_usecase.dart';
import 'domain/usecases/watch_tasks_usecase.dart';
import 'infra/datasources/firebase_pet_tasks_datasource.dart';
import 'infra/datasources/firebase_pets_datasource.dart';
import 'infra/repositories/pet_repository_impl.dart';
import 'infra/repositories/pet_task_repository_impl.dart';
import 'presentation/controllers/pet_controller.dart';
import 'presentation/controllers/pet_task_controller.dart';
import 'presentation/pages/pet_details_page.dart';
import 'presentation/pages/pet_edit_page.dart';
import 'presentation/pages/pet_tasks_page.dart';
import 'presentation/pages/pets_list_page.dart';
import 'presentation/stores/pet_store.dart';
import 'presentation/stores/pet_task_store.dart';

class PetModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.add<FirebasePetsDataSource>(FirebasePetsDataSource.new);
    i.add<PetRepository>(PetRepositoryImpl.new);
    i.addLazySingleton(PetStore.new);
    // register usecases
    i.add(WatchPetsUseCase.new);
    i.add(AddPetUseCase.new);
    i.add(UpdatePetUseCase.new);
    i.add(DeletePetUseCase.new);
    i.add(UploadImageUseCase.new);

    // pet tasks
    i.add<FirebasePetTasksDataSource>(FirebasePetTasksDataSource.new);
    i.add<PetTaskRepository>(PetTaskRepositoryImpl.new);
    i.add(WatchTasksUseCase.new);
    i.add(AddTaskUseCase.new);
    i.add(UpdateTaskUseCase.new);
    i.add(DeleteTaskUseCase.new);
    i.addLazySingleton(PetTaskStore.new);
    i.add(PetTaskController.new);

    // PetController depends on usecases and the PetStore
    i.add(PetController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (_) => PetsListPage(
        controller: Modular.get<PetController>(),
      ),
    );
    r.child(
      '/details/:id',
      child: (_) => PetDetailsPage(
        petId: r.args.params['id']!,
        controller: Modular.get<PetController>(),
      ),
    );
    r.child(
      '/details/:id/tasks',
      child: (_) => PetTasksPage(
        petId: r.args.params['id']!,
        controller: Modular.get<PetTaskController>(),
      ),
    );
    r.child(
      '/add',
      child: (_) => PetEditPage(
        controller: Modular.get<PetController>(),
      ),
    );
    r.child(
      '/edit/:id',
      child: (_) => PetEditPage(
        id: r.args.params['id'],
        controller: Modular.get<PetController>(),
      ),
    );
  }
}
