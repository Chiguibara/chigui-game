import 'package:flutter/material.dart';

import 'app.dart';
import 'game/pet_controller.dart';
import 'save/save_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = PetController(await SaveStore.open());
  runApp(ChiguiApp(controller: controller));
}
