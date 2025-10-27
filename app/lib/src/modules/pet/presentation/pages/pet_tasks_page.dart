import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/pet_task_entity.dart';
import '../controllers/pet_task_controller.dart';

class PetTasksPage extends StatefulWidget {
  final String petId;
  final PetTaskController controller;
  const PetTasksPage({
    required this.petId,
    required this.controller,
    super.key,
  });

  @override
  State<PetTasksPage> createState() => _PetTasksPageState();
}

class _PetTasksPageState extends State<PetTasksPage> {
  PetTaskController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();

    _controller.watchTasks(widget.petId);
  }

  Future<void> _showAddDialog() async {
    final titleCtrl = TextEditingController();
    DateTime? selectedDate;
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (d != null) selectedDate = d;
                    setState(() {});
                  },
                  child: const Text('Escolher data'),
                ),
                const SizedBox(width: 8),
                Text(
                  selectedDate == null
                      ? '-'
                      : selectedDate!.toLocal().toString().split(' ').first,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleCtrl.text.trim();
              if (title.isEmpty) return;
              final task = PetTaskEntity(
                id: '',
                petId: widget.petId,
                title: title,
                date: selectedDate,
              );
              await _controller.addTask(task);
              Modular.to.pop();
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.store,
      builder: (context, _) {
        final tasks = _controller.store.tasks;
        return Scaffold(
          appBar: AppBar(title: const Text('Tarefas')),
          body: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, i) {
              final t = tasks[i];
              return ListTile(
                title: Text(t.title),
                subtitle: Text(
                  t.date == null
                      ? '-'
                      : t.date!.toLocal().toString().split(' ').first,
                ),
                trailing: IconButton(
                  icon: Icon(
                    t.done ? Icons.check_box : Icons.check_box_outline_blank,
                  ),
                  onPressed: () async {
                    final updated = t.copyWith(done: !t.done);
                    await _controller.updateTask(updated);
                  },
                ),
                onLongPress: () async {
                  await _controller.deleteTask(t.id);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddDialog,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
