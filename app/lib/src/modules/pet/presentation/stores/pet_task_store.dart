import 'package:flutter/foundation.dart';

import '../../domain/entities/pet_task_entity.dart';

class PetTaskStore extends ChangeNotifier {
  List<PetTaskEntity> tasks = [];
  bool isLoading = false;

  void setTasks(List<PetTaskEntity> items) {
    tasks = items;
    notifyListeners();
  }

  void setLoading(bool v) {
    isLoading = v;
    notifyListeners();
  }
}
