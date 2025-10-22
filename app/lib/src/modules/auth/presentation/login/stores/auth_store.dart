import 'package:flutter/foundation.dart';

import 'auth_state.dart';

class AuthStore extends ChangeNotifier {
  AuthState _state = AuthIdle();

  AuthState get state => _state;

  void setState(AuthState s) {
    _state = s;
    notifyListeners();
  }
}
