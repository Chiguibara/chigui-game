import 'package:flutter/material.dart';

import 'app.dart';
import 'data/json_game_repository.dart';
import 'game/pet_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await PetController.load(await JsonGameRepository.open());
  runApp(ChiguiApp(controller: controller));
}
