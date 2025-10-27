import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_task_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_task_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/delete_task_usecase.dart';

import 'delete_task_usecase_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<PetTaskRepository>(),
])
void main() {
  group('Unit Test - DeleteTaskUseCase', () {
    test(
      'Dado um id de tarefa,\nQuando eu chamar DeleteTaskUseCase.call,\nEntão a tarefa deve ser removida',
      () async {
        final repo = MockPetTaskRepository();
        final usecase = DeleteTaskUseCase(repo);
        final t = PetTaskEntity(id: 'tt1', petId: 'p1', title: 'T');
        when(repo.addTask(any)).thenAnswer(
          (inv) async => inv.positionalArguments[0] as PetTaskEntity,
        );
        when(repo.deleteTask('tt1')).thenAnswer((_) async => Future.value());
        await repo.addTask(t);
        await usecase.call('tt1');
        verify(repo.deleteTask('tt1')).called(1);
      },
    );
  });
}
