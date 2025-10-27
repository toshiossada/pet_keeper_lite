import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petkeeperlite/src/modules/pet/domain/repositories/pet_repository.dart';
import 'package:petkeeperlite/src/modules/pet/domain/usecases/upload_image_usecase.dart';

import 'upload_image_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PetRepository>(),
])
void main() {
  group('Unit Test - UploadImageUseCase', () {
    test(
      'Dado um arquivo e nome,\nQuando eu chamar UploadImageUseCase.call,\nEntão deve retornar uma URL simulada',
      () async {
        final repo = MockPetRepository();
        final usecase = UploadImageUseCase(repo);
        final file = File('dummy');
        when(
          repo.uploadImage(any, any),
        ).thenAnswer((inv) async => 'https://fake/img.png');
        final url = await usecase.call(file, 'img.png');
        expect(url, contains('https://fake/img.png'));
        verify(repo.uploadImage(file, 'img.png')).called(1);
      },
    );
  });
}
