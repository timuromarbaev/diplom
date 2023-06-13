import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:translator/translator.dart'; //Google translator dart package
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart'; //Language Identifying dart package
import 'package:flutter/services.dart'; //Package For platform exception when Identifying language
import 'package:flutter_tts/flutter_tts.dart'; //Text To Speech dart package
import 'package:google_translator/google_translator.dart'; //Google Translator API
import 'package:speech_to_text/speech_to_text.dart'; //Speech To Text dart package

import 'package:avatar_glow/avatar_glow.dart';
import 'package:language_detection_diplom/pages/profile_page.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  @override
  List<ScreenHiddenDrawer> _pages = [];

  final myTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Homepage',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: const Color.fromARGB(255, 58, 112, 206),
        ),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Favorites',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: const Color.fromARGB(255, 58, 112, 206),
        ),
        const ProfilePage(),
      ),
    ];
  }

  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color.fromARGB(221, 50, 50, 50),
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 45,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Text Field
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    languageIdentifier.close();
    _textController.dispose();
    super.dispose();
  }

  //Clear TextField and translated text
  void _clearText() {
    setState(() {
      _textController.clear();
      _translatedText = 'Translation';
      identifiedLanguage = 'Autodetect language';
    });
  }

  //Text To Speech
  final FlutterTts tts = FlutterTts();

  void textToSpeech(String text) async {
    await tts.setLanguage(identifiedLanguage);
    await tts.setVolume(0.5);
    await tts.setSpeechRate(0.5);
    await tts.setPitch(1);
    await tts.speak(text);
  }

  //Speech To Text
  SpeechToText stt = SpeechToText();
  bool isListening = false;

  //Translator instance
  final translator = GoogleTranslator();
  // Where inputted text stored
  String inputText = '';
  //Placeholder text
  String _translatedText = 'Translation';
  //Initial language to translate to
  String targetLang = 'ru';

  Future<void> translateLanguage(String textController) async {
    final translation = await inputText.translate(
      from: 'auto',
      to: targetLang,
    );
    setState(() {
      _translatedText = translation.text;
      identifyLanguage();
    });
  }

  //Lang id instance
  final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  //Identified Language
  String identifiedLanguage = '';

  //Language Identifier Function
  Future<void> identifyLanguage() async {
    if (_textController.text == '') return;
    String language;
    try {
      language =
          await languageIdentifier.identifyLanguage(_textController.text);
    } on PlatformException catch (pe) {
      if (pe.code == languageIdentifier.undeterminedLanguageCode) {
        language = 'error: no language identified!';
      }
      language = 'error: ${pe.code}: ${pe.message}';
    } catch (e) {
      language = 'error: ${e.toString()}';
    }
    setState(() {
      identifiedLanguage = language;
    });
  }

  //Languages for Dropdown
  List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'kk', 'name': 'Kazakh'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'be', 'name': 'Belarusian'},
    {'code': 'zh-CN', 'name': 'Chinese (Simplified)'},
    {'code': 'cs', 'name': 'Czech'},
    {'code': 'da', 'name': 'Danish'},
    {'code': 'nl', 'name': 'Dutch'},
    {'code': 'et', 'name': 'Estonian'},
    {'code': 'fi', 'name': 'Finnish'},
    {'code': 'ka', 'name': 'Georgian'},
    {'code': 'de', 'name': 'German'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'ko', 'name': 'Korean'},
    {'code': 'ky', 'name': 'Kyrgyz'},
    {'code': 'pl', 'name': 'Polish'},
    {'code': 'es', 'name': 'Spanish'},
  ];

  List<DropdownMenuItem<String>> buildLanguageItems() {
    return languages
        .map((language) => DropdownMenuItem(
              value: language['code'],
              child: Text(language['name']!),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(221, 70, 70, 70),
      body: Card(
        margin: const EdgeInsets.all(12.0),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Detected Language
            identifiedLanguage == ''
                ? const Text(
                    'Detect language',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ).translate()
                : Text(
                    identifiedLanguage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(height: 18.0),

            // Text Field and Translation
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                      maxLines: 1,
                      controller: _textController,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter text',
                      ),
                      onChanged: (inputText) async {
                        final translation = await inputText.translate(
                          from: 'auto',
                          to: targetLang,
                        );
                        setState(() {
                          _translatedText = translation.text;
                          identifyLanguage();
                        });
                      }),
                ),

                //Icon Button Clear
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearText,
                  ),
                )
              ], //children
            ),

            const Divider(height: 32),

            //Translation Language
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: const Text(
                    'Translate to:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ).translate(),
                ),

                // Dropdown Button of languages
                Expanded(
                  flex: 2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      isExpanded: true,
                      value: targetLang,
                      items: buildLanguageItems(),
                      onChanged: (value) => setState(() {
                        targetLang = value!;
                      }),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            //Translated Text, Result
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    _translatedText,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 58, 112, 206),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //Text to speech button
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () => textToSpeech(_translatedText),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  saveTranslation(
                    sourceTranslation: _textController.text,
                    targetTranslation: _translatedText,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 58, 112, 206),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(microseconds: 2000),
        glowColor: const Color.fromARGB(255, 58, 112, 206),
        repeat: true,
        repeatPauseDuration: const Duration(microseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!isListening) {
              var available = await stt.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  stt.listen(
                    onResult: (result) {
                      setState(() {
                        _textController.text = '${result.recognizedWords} ';
                      });
                    },
                  );
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              isListening = false;
            });
            stt.stop();
            translateLanguage(_textController.text);
          },
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 58, 112, 206),
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future saveTranslation({
    required String sourceTranslation,
    required String targetTranslation,
  }) async {
    try {
      final docTrans =
          FirebaseFirestore.instance.collection('translation').doc();

      final transModel = TranslationPair(
        id: docTrans.id,
        sourceTranslation: _textController.text,
        targetTranslation: _translatedText,
      );

      final json = transModel.toJson();

      await docTrans.set(json);
    } catch (e) {
      print('Error saving text to Firestore: $e');
    }
  }
}

class TranslationPair {
  String id;
  final String sourceTranslation;
  final String targetTranslation;

  TranslationPair({
    this.id = '',
    required this.sourceTranslation,
    required this.targetTranslation,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sourceTranslation': sourceTranslation,
        'targetTranslation': targetTranslation,
      };

  static TranslationPair fromJson(Map<String, dynamic> json) => TranslationPair(
        sourceTranslation: json['source_language'],
        targetTranslation: json['target_language'],
      );
}
