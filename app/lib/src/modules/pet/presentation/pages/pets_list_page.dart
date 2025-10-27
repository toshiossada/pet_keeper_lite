import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../controllers/pet_controller.dart';

class PetsListPage extends StatefulWidget {
  final PetController controller;
  const PetsListPage({required this.controller, super.key});

  @override
  State<PetsListPage> createState() => _PetsListPageState();
}

class _PetsListPageState extends State<PetsListPage> {
  @override
  void initState() {
    super.initState();

    widget.controller.watchPets();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller.store,
      builder: (context, _) {
        final pets = widget.controller.store.pets;
        return Scaffold(
          appBar: AppBar(title: const Text('Pets')),
          body: RefreshIndicator(
            onRefresh: () async {
              widget.controller.watchPets();
            },
            child: ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, i) {
                final pet = pets[i];
                return ListTile(
                  onLongPress: () {
                    widget.controller.deletePet(pet.id);
                  },
                  trailing: IconButton(
                    onPressed: () {
                      Modular.to.pushNamed(
                        '/pet/edit/${pet.id}',
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  leading: pet.photoUrl.isNotEmpty
                      ? Image.network(
                          pet.photoUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(width: 56, height: 56),
                  title: Text(pet.familyCode),
                  subtitle: Text('${pet.specie} • ${pet.weightKg} kg'),
                  onTap: () => Modular.to.pushNamed(
                    '/pet/details/${pet.id}',
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Modular.to.pushNamed(
              '/pet/add',
            ),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
