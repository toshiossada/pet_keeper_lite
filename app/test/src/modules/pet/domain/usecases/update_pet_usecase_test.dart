import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/entities/pet_entity.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/update_pet_usecase.dart';

import 'update_pet_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PetRepository>(),
])
void main() {
  group('Unit Test - UpdatePetUseCase', () {
    test(
      'Dado um PetEntity existente,\nQuando eu chamar UpdatePetUseCase.call,\nEntão o pet deve ser atualizado e retornado',
      () async {
        final repo = MockPetRepository();
        final usecase = UpdatePetUseCase(repo);
        final pet = PetEntity(
          id: 'up1',
          name: 'Old',
          specie: 'S',
          weightKg: 2,
          photoUrl: '',
          familyCode: 'f',
        );
        when(
          repo.addPet(any),
        ).thenAnswer((inv) async => inv.positionalArguments[0] as PetEntity);
        await repo.addPet(pet);
        final updated = pet.copyWith(name: 'New');
        when(
          repo.updatePet(any),
        ).thenAnswer((inv) async => inv.positionalArguments[0] as PetEntity);
        final res = await usecase.call(updated);
        expect(res.name, equals('New'));
        verify(repo.updatePet(updated)).called(1);
      },
    );
  });
}
