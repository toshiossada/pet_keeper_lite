import 'package:flutter/foundation.dart';

import 'signup_state.dart';

class SignUpStore extends ChangeNotifier {
  SignUpState _state = SignUpIdle();

  SignUpState get state => _state;

  set state(SignUpState s) {
    _state = s;
    notifyListeners();
  }
}
