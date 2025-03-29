import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_flutter/src/apps/my_app.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
