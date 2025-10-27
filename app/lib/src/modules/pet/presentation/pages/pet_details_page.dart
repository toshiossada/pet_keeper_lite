import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/pet_entity.dart';
import '../controllers/pet_controller.dart';
import '../controllers/pet_task_controller.dart';
import 'pet_tasks_page.dart';

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
  PetTaskController get _taskController => widget.controller.taskController;
  PetController get controller => widget.controller;
  PetEntity get pet =>
      controller.store.pets.firstWhere((p) => p.id == widget.petId);

  @override
  void initState() {
    super.initState();

    _taskController.watchTasks(widget.petId);
  }

  Future<void> _notifyFamily(String message) async {
    try {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('notifyFamily');

      await callable.call(<String, dynamic>{
        'petId': pet.id,
        'message': message,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notificação enviada à família')),
        );
      }
    } catch (e, st) {
      debugPrint('notifyFamily unknown error: $e');
      debugPrintStack(stackTrace: st);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao notificar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_note),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PetTasksPage(
                  petId: pet.id,
                  controller: Modular.get<PetTaskController>(),
                ),
              ),
            ),
          ),
        ],
      ),
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
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Tarefas / Vacinas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _taskController.store,
              builder: (context, _) {
                final tasks = _taskController.store.tasks;
                if (tasks.isEmpty) {
                  return const Text('Nenhuma tarefa cadastrada');
                }
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final t = tasks[i];
                    return ListTile(
                      title: Text(t.title),
                      subtitle: Text(
                        t.date == null
                            ? '-'
                            : t.date!.toLocal().toString().split(' ').first,
                      ),
                      trailing: ElevatedButton(
                        onPressed: () =>
                            _notifyFamily('Nova tarefa: ${t.title}'),
                        child: const Text('Avisar família'),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: tasks.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
