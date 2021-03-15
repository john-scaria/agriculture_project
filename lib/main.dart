import 'package:agriculture_project/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  const riveFileName = 'assets/agriculture_map.riv';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final bytes = await rootBundle.load(riveFileName);
  final file = RiveFile();
  file.import(bytes);

  runApp(MyApp(
    riveFile: file,
  ));
}
