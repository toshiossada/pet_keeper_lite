import 'package:flutter/foundation.dart';

import '../../domain/entities/pet_entity.dart';

class PetStore extends ChangeNotifier {
  List<PetEntity> pets = [];
  PetEntity? selected;
  bool isLoading = false;

  void setPets(List<PetEntity> items) {
    pets = items;
    notifyListeners();
  }

  void setSelected(PetEntity? p) {
    selected = p;
    notifyListeners();
  }

  void setLoading(bool l) {
    isLoading = l;
    notifyListeners();
  }
}
