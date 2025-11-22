import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/contact.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Hive
  await Hive.initFlutter();

  // Enregistrer l'adapter du modèle Contact
  Hive.registerAdapter(ContactAdapter());

  // Ouvrir la box des contacts
  await Hive.openBox<Contact>('contactsBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Contacts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), // تنجم تخلي const
    );
  }
}
