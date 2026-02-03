import 'package:flutter/material.dart';

import 'app.dart';
import 'config/env_config.dart';
import 'config/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await EnvConfig.load();
  await initInjectionContainer();
  runApp(const App());
}
