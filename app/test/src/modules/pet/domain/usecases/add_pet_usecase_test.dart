import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/add_pet_usecase.dart';

import 'add_pet_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PetRepository>(),
])
void main() {
  group('Unit Test - AddPetUseCase', () {
    test(
      'Dado um PetEntity,\nQuando eu chamar AddPetUseCase.call,\nEntão o pet deve ser adicionado e retornado',
      () async {
        final repo = MockPetRepository();
        final usecase = AddPetUseCase(repo);
        final pet = PetEntity(
          id: 'p1',
          name: 'Rex',
          specie: 'Dog',
          weightKg: 3.2,
          photoUrl: '',
          familyCode: 'f1',
        );
        when(
          repo.addPet(any),
        ).thenAnswer((inv) async => inv.positionalArguments[0] as PetEntity);
        final res = await usecase.call(pet);
        expect(res.id, equals('p1'));
        verify(repo.addPet(pet)).called(1);
      },
    );
  });
}
