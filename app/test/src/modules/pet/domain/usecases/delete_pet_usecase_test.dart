import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/delete_pet_usecase.dart';

import 'delete_pet_usecase_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<PetRepository>(),
])
void main() {
  group('Unit Test - DeletePetUseCase', () {
    test(
      'Dado um id de pet,\nQuando eu chamar DeletePetUseCase.call,\nEntão o pet deve ser removido do repositório',
      () async {
        final repo = MockPetRepository();
        final usecase = DeletePetUseCase(repo);
        final pet = PetEntity(
          id: 'p9',
          name: 'X',
          specie: 'S',
          weightKg: 1,
          photoUrl: '',
          familyCode: 'f',
        );
        when(
          repo.addPet(any),
        ).thenAnswer((inv) async => inv.positionalArguments[0] as PetEntity);
        when(repo.deletePet('p9')).thenAnswer((_) async => Future.value());
        await repo.addPet(pet);
        await usecase.call('p9');
        verify(repo.deletePet('p9')).called(1);
        verify(repo.addPet(pet)).called(1);
      },
    );
  });
}
