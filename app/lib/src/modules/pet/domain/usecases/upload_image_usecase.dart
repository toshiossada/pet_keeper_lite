import 'dart:io';

import '../repositories/pet_repository.dart';

class UploadImageUseCase {
  final PetRepository repository;
  UploadImageUseCase(this.repository);

  Future<String> call(File file, String filename) =>
      repository.uploadImage(file, filename);
}
