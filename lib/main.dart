import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mailbox/presentation/pages/start.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StartPage());
}

