import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/pet_entity.dart';
import '../controllers/pet_controller.dart';

class PetEditPage extends StatefulWidget {
  final String? id;
  final PetController controller;
  const PetEditPage({required this.controller, this.id, super.key});

  @override
  State<PetEditPage> createState() => _PetEditPageState();
}

class _PetEditPageState extends State<PetEditPage> {
  PetController get controller => widget.controller;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _specieCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  DateTime? _birthDate;
  File? _imageFile;
  PetEntity? pet;

  @override
  void initState() {
    super.initState();

    pet = controller.store.pets
        .where(
          (p) => p.id == widget.id,
        )
        .firstOrNull;
    if (pet != null) {
      _nameCtrl.text = pet!.name;
      _specieCtrl.text = pet!.specie;
      _weightCtrl.text = pet!.weightKg.toString();
      _birthDate = pet!.birthDate;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _specieCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (x != null) setState(() => _imageFile = File(x.path));
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final pet = PetEntity(
      id: this.pet?.id ?? '',
      familyCode: this.pet?.familyCode ?? '',
      name: _nameCtrl.text.trim(),
      specie: _specieCtrl.text.trim(),
      birthDate: _birthDate,
      weightKg: double.tryParse(_weightCtrl.text) ?? 0,
      photoUrl: this.pet?.photoUrl ?? '',
      createdAt: this.pet?.createdAt,
    );
    if (this.pet == null) {
      await controller.addPet(pet, imageFile: _imageFile, familyCode: '1');
    } else {
      await controller.updatePet(pet, imageFile: _imageFile);
    }
    if (mounted) Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet == null ? 'Adicionar Pet' : 'Editar Pet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : (pet != null && pet!.photoUrl.isNotEmpty)
                    ? Image.network(
                        pet!.photoUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(Icons.add_a_photo),
                      ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _specieCtrl,
                decoration: const InputDecoration(labelText: 'Espécie'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a espécie' : null,
              ),
              TextFormField(
                controller: _weightCtrl,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _save, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
