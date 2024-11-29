import 'package:drone_factory/data/db_handler.dart';
import 'package:drone_factory/firebase_options.dart';
import 'package:drone_factory/models/native_synthesizer.dart';
import 'package:drone_factory/providers/auth_provider.dart';
import 'package:drone_factory/providers/base_frequency_provider.dart';
import 'package:drone_factory/providers/patch_provider.dart';
import 'package:drone_factory/providers/track_provider.dart';
import 'package:drone_factory/views/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dbHandler = DbHandler();
  await dbHandler.deleteDb();
  await dbHandler.initDb();
  
  final NativeSynthesizer synthesizer = NativeSynthesizer();
  final BaseFrequencyProvider baseFrequencyProvider = BaseFrequencyProvider();
  final PatchProvider patchProvider = PatchProvider();
  final TrackProvider trackProvider = TrackProvider(synthesizer, patchProvider.currentPatch, baseFrequencyProvider);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => baseFrequencyProvider),
        ChangeNotifierProvider(create: (context) => patchProvider),
        ChangeNotifierProvider(create: (context) => trackProvider),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MainApp(synthesizer: synthesizer),
    ),
  );
}

class MainApp extends StatelessWidget {
  final NativeSynthesizer synthesizer;

  const MainApp({
    super.key,
    required this.synthesizer,
    });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.amber,
            fontSize: 20,
            fontFamily: 'CocomatLight',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DRONE FACTORY'),
        ),
        body: const Home(),
      ),
    );
  }
}