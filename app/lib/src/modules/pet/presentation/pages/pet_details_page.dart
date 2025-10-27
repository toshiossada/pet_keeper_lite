import 'package:flutter/material.dart';

import '../../domain/entities/pet_entity.dart';
import '../controllers/pet_controller.dart';

class PetDetailsPage extends StatefulWidget {
  final String petId;
  final PetController controller;
  const PetDetailsPage({
    required this.petId,
    required this.controller,
    super.key,
  });

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  PetController get controller => widget.controller;
  PetEntity get pet =>
      controller.store.pets.firstWhere((p) => p.id == widget.petId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pet.photoUrl.isNotEmpty)
              Image.network(
                pet.photoUrl,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 12),
            Text(
              'Nome: ${pet.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Espécie: ${pet.specie}'),
            const SizedBox(height: 8),
            Text('Peso: ${pet.weightKg} kg'),
            const SizedBox(height: 8),
            Text(
              'Nascimento: '
              '${pet.birthDate?.toLocal().toString().split(" ").first ?? "-"}',
            ),
          ],
        ),
      ),
    );
  }
}
