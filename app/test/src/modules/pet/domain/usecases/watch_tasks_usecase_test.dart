import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_task_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_task_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/watch_tasks_usecase.dart';

import 'watch_tasks_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PetTaskRepository>(),
])
void main() {
  group('Unit Test - WatchTasksUseCase', () {
    test(
      'Dado tarefas associadas a um pet,\nQuando eu chamar WatchTasksUseCase.call com o petId,\nEntão o stream deve emitir apenas as tarefas desse pet',
      () async {
        final repo = MockPetTaskRepository();
        final usecase = WatchTasksUseCase(repo);
        final a = PetTaskEntity(id: 'x1', petId: 'pX', title: 'A');
        // b omitted - not used in this test
        when(repo.watchTasks(any)).thenAnswer((inv) => Stream.value([a]));
        final emitted = await usecase.call('pX').first;
        expect(emitted.length, equals(1));
        expect(emitted.first.id, equals('x1'));
        verify(repo.watchTasks('pX')).called(1);
      },
    );
  });
}
