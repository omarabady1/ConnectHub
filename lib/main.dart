import 'package:connect_hub/core/functions/setup_service_locator.dart';
import 'package:connect_hub/core/helper_functions.dart/on_generate_routes.dart';
import 'package:connect_hub/core/services/shared_preferences_singleton.dart';
import 'package:connect_hub/features/home/presentation/views/home_view.dart';
import 'package:connect_hub/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Prefs.init();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
      initialRoute: HomeView.routeName,
    );
  }
}
