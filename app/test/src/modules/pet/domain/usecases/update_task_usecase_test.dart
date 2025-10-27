import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_task_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_task_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/update_task_usecase.dart';

// Use generated MockPetTaskRepository from test_mocks.mocks.dart
import 'update_task_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PetTaskRepository>(),
])
void main() {
  group('Unit Test - UpdateTaskUseCase', () {
    test(
      'Dado uma PetTaskEntity existente,\nQuando eu chamar UpdateTaskUseCase.call,\nEntão a tarefa deve ser atualizada',
      () async {
        final repo = MockPetTaskRepository();
        final usecase = UpdateTaskUseCase(repo);
        final t = PetTaskEntity(id: 'tt', petId: 'p', title: 'Old');
        when(repo.addTask(any)).thenAnswer(
          (inv) async => inv.positionalArguments[0] as PetTaskEntity,
        );
        await repo.addTask(t);
        final updated = t.copyWith(title: 'New');
        when(repo.updateTask(any)).thenAnswer(
          (inv) async => inv.positionalArguments[0] as PetTaskEntity,
        );
        final res = await usecase.call(updated);
        expect(res.title, equals('New'));
        verify(repo.updateTask(updated)).called(1);
      },
    );
  });
}
