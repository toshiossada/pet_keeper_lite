import 'package:flutter/material.dart';

import '../../domain/entitites/user_entity.dart';

class AppStore extends ChangeNotifier {
  UserEntity? _user;
  UserEntity? get user => _user;
  set user(UserEntity? user) {
    _user = user;
    notifyListeners();
  }
}
