import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/controllers/app_controller.dart';
import 'presenter/stores/app_store.dart';

class CoreModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(AppStore.new);
    i.addLazySingleton(AppController.new);
  }
}
