import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_task_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_task_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/add_task_usecase.dart';

import 'add_task_usecase_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<PetTaskRepository>(),
])
void main() {
  group('Unit Test - AddTaskUseCase', () {
    test(
      'Dado uma PetTaskEntity,\nQuando eu chamar AddTaskUseCase.call,\nEntão a tarefa deve ser adicionada e retornada',
      () async {
        final repo = MockPetTaskRepository();
        final usecase = AddTaskUseCase(repo);
        final t = PetTaskEntity(id: 't1', petId: 'p1', title: 'Vacina');
        when(repo.addTask(any)).thenAnswer(
          (inv) async => inv.positionalArguments[0] as PetTaskEntity,
        );
        final res = await usecase.call(t);
        expect(res.id, equals('t1'));
        verify(repo.addTask(t)).called(1);
      },
    );
  });
}
