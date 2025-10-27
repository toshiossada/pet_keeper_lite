import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_task_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_task_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/add_pet_usecase.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/add_task_usecase.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/delete_pet_usecase.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/delete_task_usecase.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/update_pet_usecase.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/update_task_usecase.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/upload_image_usecase.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/watch_pets_usecase.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/watch_tasks_usecase.dart';

import 'pet_usecases_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PetRepository>(),
  MockSpec<PetTaskRepository>(),
])
void main() {
  group('Usecases - Pets', () {
    late MockPetRepository repo;
    late AddPetUseCase addPet;
    late UpdatePetUseCase updatePet;
    late DeletePetUseCase deletePet;
    late UploadImageUseCase uploadImage;
    late WatchPetsUseCase watchPets;

    setUp(() {
      repo = MockPetRepository();
      addPet = AddPetUseCase(repo);
      updatePet = UpdatePetUseCase(repo);
      deletePet = DeletePetUseCase(repo);
      uploadImage = UploadImageUseCase(repo);
      watchPets = WatchPetsUseCase(repo);
    });

    test(
      'Dado um PetEntity, \n'
      'Quando eu chamar AddPetUseCase.call, \n'
      'Então o pet deve ser adicionado e retornado',
      () async {
        final pet = PetEntity(
          id: 'p1',
          name: 'Rex',
          specie: 'Dog',
          weightKg: 4.2,
          photoUrl: 'u',
          familyCode: 'f1',
        );
        when(repo.addPet(any)).thenAnswer((_) async => pet);
        final created = await addPet.call(pet);
        expect(created.id, equals('p1'));
        verify(repo.addPet(pet)).called(1);
      },
    );

    test(
      'Dado um PetEntity existente, \n'
      'Quando eu chamar UpdatePetUseCase.call, \n'
      'Então o pet deve ser atualizado e retornado',
      () async {
        final pet = PetEntity(
          id: 'p2',
          name: 'Bela',
          specie: 'Cat',
          weightKg: 3,
          photoUrl: '',
          familyCode: 'f2',
        );
        final updatedPet = pet.copyWith(name: 'BelaUpdated');
        when(repo.updatePet(any)).thenAnswer((_) async => updatedPet);
        final res = await updatePet.call(updatedPet);
        expect(res.name, equals('BelaUpdated'));
        verify(repo.updatePet(updatedPet)).called(1);
      },
    );

    test(
      'Dado um id de pet, \n'
      'Quando eu chamar DeletePetUseCase.call, \n'
      'Então o pet deve ser removido do repositório',
      () async {
        final pet = PetEntity(
          id: 'p3',
          name: 'Toto',
          specie: 'Dog',
          weightKg: 2,
          photoUrl: '',
          familyCode: 'f1',
        );
        when(repo.deletePet('p3')).thenAnswer((_) async => Future.value());
        await deletePet.call('p3');
        verify(repo.deletePet('p3')).called(1);
      },
    );

    test(
      'Dado um arquivo e nome, \n'
      'Quando eu chamar UploadImageUseCase.call, \n'
      'Então deve retornar uma URL simulada',
      () async {
        final file = File('test.txt');
        when(
          repo.uploadImage(any, any),
        ).thenAnswer((_) async => 'https://fake.storage/img.png');
        final url = await uploadImage.call(file, 'img.png');
        expect(url, equals('https://fake.storage/img.png'));
      },
    );

    test(
      'Dado vários pets com familyCode, \n'
      'Quando eu chamar WatchPetsUseCase.call com um familyCode, \n'
      'Então o stream deve emitir apenas os pets pertencentes a esse familyCode',
      () async {
        final p1 = PetEntity(
          id: 'a',
          name: 'A',
          specie: 'S',
          weightKg: 1,
          photoUrl: '',
          familyCode: 'fam1',
        );
        // second pet not needed for this test
        when(repo.watchPets('fam1')).thenAnswer((_) => Stream.value([p1]));
        final list = await watchPets.call('fam1').first;
        expect(list.length, equals(1));
        expect(list.first.id, equals('a'));
      },
    );
  });

  group('Usecases - PetTasks', () {
    late MockPetTaskRepository repo;
    late AddTaskUseCase addTask;
    late UpdateTaskUseCase updateTask;
    late DeleteTaskUseCase deleteTask;
    late WatchTasksUseCase watchTasks;

    setUp(() {
      repo = MockPetTaskRepository();
      addTask = AddTaskUseCase(repo);
      updateTask = UpdateTaskUseCase(repo);
      deleteTask = DeleteTaskUseCase(repo);
      watchTasks = WatchTasksUseCase(repo);
    });

    test(
      'Dado uma PetTaskEntity, \n'
      'Quando eu chamar AddTaskUseCase.call, \n'
      'Então a tarefa deve ser adicionada e retornada',
      () async {
        final t = PetTaskEntity(id: 't1', petId: 'p1', title: 'Vacina');
        when(repo.addTask(any)).thenAnswer((_) async => t);
        final created = await addTask.call(t);
        expect(created.id, equals('t1'));
        verify(repo.addTask(t)).called(1);
      },
    );

    test(
      'Dado uma PetTaskEntity existente, \n'
      'Quando eu chamar UpdateTaskUseCase.call, \n'
      'Então a tarefa deve ser atualizada',
      () async {
        final t = PetTaskEntity(id: 't2', petId: 'p2', title: 'V1');
        final updated = t.copyWith(title: 'V1-up');
        when(repo.updateTask(any)).thenAnswer((_) async => updated);
        final res = await updateTask.call(updated);
        expect(res.title, equals('V1-up'));
        verify(repo.updateTask(updated)).called(1);
      },
    );

    test(
      'Dado um id de tarefa, \n'
      'Quando eu chamar DeleteTaskUseCase.call, \n'
      'Então a tarefa deve ser removida',
      () async {
        when(repo.deleteTask('t3')).thenAnswer((_) async => Future.value());
        await deleteTask.call('t3');
        verify(repo.deleteTask('t3')).called(1);
      },
    );

    test(
      'Dado tarefas associadas a um pet, \n'
      'Quando eu chamar WatchTasksUseCase.call com o petId, \n'
      'Então o stream deve emitir apenas as tarefas desse pet',
      () async {
        final a = PetTaskEntity(id: 'x1', petId: 'pX', title: 'A');
        // second task omitted
        when(repo.watchTasks('pX')).thenAnswer((_) => Stream.value([a]));
        final emitted = await watchTasks.call('pX').first;
        expect(emitted.length, equals(1));
        expect(emitted.first.id, equals('x1'));
      },
    );
  });
}
