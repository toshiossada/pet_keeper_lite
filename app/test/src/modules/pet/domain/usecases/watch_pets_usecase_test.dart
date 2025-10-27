import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/watch_pets_usecase.dart';

import 'watch_pets_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PetRepository>(),
])
void main() {
  group('Unit Test - WatchPetsUseCase', () {
    test(
      'Dado vários pets com familyCode,\nQuando eu chamar WatchPetsUseCase.call com um familyCode,\nEntão o stream deve emitir apenas os pets pertencentes a esse familyCode',
      () async {
        final repo = MockPetRepository();
        final usecase = WatchPetsUseCase(repo);
        final p1 = PetEntity(
          id: 'a',
          name: 'A',
          specie: 'S',
          weightKg: 1,
          photoUrl: '',
          familyCode: 'fam1',
        );
        // p2 omitted - not needed for this test
        when(repo.watchPets(any)).thenAnswer((_) => Stream.value([p1]));
        final list = await usecase.call('fam1').first;
        expect(list.length, equals(1));
        expect(list.first.id, equals('a'));
        verify(repo.watchPets('fam1')).called(1);
      },
    );
  });
}
