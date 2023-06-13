import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:language_detection_diplom/pages/home_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final apiKey = 'AIzaSyCl9vBoC8hytx6CBybQN947IGGT1AwZJes';

  @override
  Widget build(BuildContext context) {
    return GoogleTranslatorInit(
      apiKey,
      translateFrom: const Locale('en'),
      translateTo: const Locale('ru'),
      automaticDetection: true,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: const HiddenDrawer(),
      ),
    );
  }
}
